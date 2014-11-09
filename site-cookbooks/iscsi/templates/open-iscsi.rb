# List of LVMed iSCSI Volume Groups.
# Multiple Volume Groups can be specified with spaces
LVMGROUPS="vg_iscsi01"


# Handle _netdev devices
# You can specify your iSCSI (LVMed or Multipathed or DM Encrypted) devices
# with the _netdev mount option and open-iscsi will treat them accordingly
#
# Note: However, Hanling _netdev devices comes with the caveat that other _netdev mounts,
# like an NFS share, also get pulled in with it
HANDLE_NETDEV=1
