%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE
from starkware.starknet.common.syscalls import get_caller_address
from openzeppelin.access.accesscontrol.library import AccessControl

@event
func AdminAdded(address: felt) {
}

@event
func AdminRemoved(address: felt) {
}

@event
func EventMinterAdded(event_id: felt, account: felt) {
}

@event
func EventMinterRemoved(event_id: felt, account: felt) {
}

@storage_var
func PoapRoles_admins(address: felt) -> (is_admin: felt) {
}

@storage_var
func PoapRoles_minters(event_id: felt, account: felt) -> (is_minter: felt) {
}

namespace PoapRoles {
    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        sender: felt
    ) {
        let is_admin = PoapRoles_admins.read(sender);
        if (is_admin != TRUE) {
            PoapRoles_admins.write(sender, TRUE);
        }
        return ();
    }

    func only_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (message_sender) = get_caller_address();
        let (is_admin) = PoapRoles_admins.read(message_sender);
        with_attr error_message("Message sender is not admim") {
            assert is_admin = TRUE;
        }
        return ();
    }
}
