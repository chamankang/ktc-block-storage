# vim: tabstop=4 shiftwidth=4 softtabstop=4

# Copyright 2010 United States Government as represented by the
# Administrator of the National Aeronautics and Space Administration.
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
"""
Helper code for the iSCSI volume driver.

"""
import os
import re

from cinder import exception
from cinder import flags
from cinder.openstack.common import cfg
from cinder.openstack.common import log as logging
from cinder import utils
from pprint import pprint

LOG = logging.getLogger(__name__)

iscsi_helper_opt = [
        cfg.StrOpt('iscsi_helper',
                    default='tgtadm',
                    help='iscsi target user-land tool to use'),
        cfg.StrOpt('volumes_dir',
                   default='$state_path/volumes',
                   help='Volume configuration file storage directory'),
]

FLAGS = flags.FLAGS
FLAGS.register_opts(iscsi_helper_opt)


class TargetAdmin(object):
    """iSCSI target administration.

    Base class for iSCSI target admin helpers.
    """

    def __init__(self, cmd, execute):
        self._cmd = cmd
        self.set_execute(execute)

    def set_execute(self, execute):
        """Set the function to be used to execute commands."""
        self._execute = execute

    def _run(self, *args, **kwargs):
        self._execute(self._cmd, *args, run_as_root=True, **kwargs)

    def create_iscsi_target(self, name, tid, lun, path, **kwargs):
        """Create a iSCSI target and logical unit"""
        raise NotImplementedError()

    def remove_iscsi_target(self, tid, lun, vol_id, **kwargs):
        """Remove a iSCSI target and logical unit"""
        raise NotImplementedError()

    def _new_target(self, name, tid, **kwargs):
        """Create a new iSCSI target."""
        raise NotImplementedError()

    def _delete_target(self, tid, **kwargs):
        """Delete a target."""
        raise NotImplementedError()

    def show_target(self, tid, iqn=None, **kwargs):
        """Query the given target ID."""
        raise NotImplementedError()

    def _new_logicalunit(self, tid, lun, path, **kwargs):
        """Create a new LUN on a target using the supplied path."""
        raise NotImplementedError()

    def _delete_logicalunit(self, tid, lun, **kwargs):
        """Delete a logical unit from a target."""
        raise NotImplementedError()


class TgtAdm(TargetAdmin):
    """iSCSI target administration using tgtadm."""

    def __init__(self, execute=utils.execute):
        super(TgtAdm, self).__init__('tgtadm', execute)

    def _get_target(self, iqn):
        (out, err) = self._execute('tgt-admin', '--show', run_as_root=True)
        lines = out.split('\n')
        for line in lines:
            if iqn in line:
                parsed = line.split()
                tid = parsed[1]
                return tid[:-1]

        return None

    def create_iscsi_target(self, name, tid, lun, path, **kwargs):
        # Note(jdg) tid and lun aren't used by TgtAdm but remain for
        # compatibility

        utils.ensure_tree(FLAGS.volumes_dir)

        vol_id = name.split(':')[1]

        iqn = '%s%s' % (FLAGS.iscsi_target_prefix, vol_id)

        tid = 1
        (out, err) = self._execute('tgt-admin', '--show', run_as_root=True)
        lines = out.split('\n')

        for line in lines:
            matches = re.match('Target ([0-9]+)', line)
            if matches is not None:
                if tid == int(matches.group(1)):
                    tid += 1
            matches = re.match('Target ([0-9]+): ' + iqn, line)
            if matches is not None:
                return tid

        self._execute('crm_register', vol_id, iqn, tid, run_as_root=True)
        return tid

    def remove_iscsi_target(self, tid, lun, vol_id, **kwargs):
        LOG.info(_('Removing volume: %s') % vol_id)
        vol_uuid_file = 'volume-%s' % vol_id

        iqn = '%s%s' % (FLAGS.iscsi_target_prefix, vol_uuid_file)

        (out, err) = self._execute('tgt-admin', '--show', run_as_root=True)
        lines = out.split('\n')

        for line in lines:
            matches = re.match('Target ([0-9]+): ' + iqn, line)
            if matches is not None:
                self._execute('crm_delete', vol_uuid_file, run_as_root=True)
                return

    def show_target(self, tid, iqn=None, **kwargs):
        if iqn is None:
            raise exception.InvalidParameterValue(
                err=_('valid iqn needed for show_target'))

        tid = self._get_target(iqn)
        if tid is None:
            raise exception.NotFound()


class IetAdm(TargetAdmin):
    """iSCSI target administration using ietadm."""

    def __init__(self, execute=utils.execute):
        super(IetAdm, self).__init__('ietadm', execute)

    def create_iscsi_target(self, name, tid, lun, path, **kwargs):
        self._new_target(name, tid, **kwargs)
        self._new_logicalunit(tid, lun, path, **kwargs)
        return tid

    def remove_iscsi_target(self, tid, lun, vol_id, **kwargs):
        LOG.info(_('Removing volume: %s') % vol_id)
        self._delete_logicalunit(tid, lun, **kwargs)
        self._delete_target(tid, **kwargs)

    def _new_target(self, name, tid, **kwargs):
        self._run('--op', 'new',
                  '--tid=%s' % tid,
                  '--params', 'Name=%s' % name,
                  **kwargs)

    def _delete_target(self, tid, **kwargs):
        self._run('--op', 'delete',
                  '--tid=%s' % tid,
                  **kwargs)

    def show_target(self, tid, iqn=None, **kwargs):
        self._run('--op', 'show',
                  '--tid=%s' % tid,
                  **kwargs)

    def _new_logicalunit(self, tid, lun, path, **kwargs):
        self._run('--op', 'new',
                  '--tid=%s' % tid,
                  '--lun=%d' % lun,
                  '--params', 'Path=%s,Type=fileio' % path,
                  **kwargs)

    def _delete_logicalunit(self, tid, lun, **kwargs):
        self._run('--op', 'delete',
                  '--tid=%s' % tid,
                  '--lun=%d' % lun,
                  **kwargs)


def get_target_admin():
    if FLAGS.iscsi_helper == 'tgtadm':
        return TgtAdm()
    else:
        return IetAdm()

