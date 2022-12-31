%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.starknet.common.syscalls import get_caller_address
from roles.library import PoapRoles

// @title Pausable
// @dev Base contract which allows children to implement an emergency stop mechanism.

@event
func Paused(account: felt) {
}

@event
func Unpaused(account: felt) {
}

@storage_var
func Poap_pausable_paused() -> (is_paused: felt) {
}

namespace PoapPausable {
    func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        Poap_pausable_paused.write(FALSE);
        return ();
    }

    // * @return true if the contract is paused, false otherwise.
    func paused{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> felt {
        let res = Poap_pausable_paused.read();
        return (res);
    }

    // @dev Modifier to make a function callable only when the contract is not paused.
    func when_not_paused{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (is_paused) = Poap_pausable_paused.read();
        with_attr error_message("Poap requires to not be paused") {
            assert is_paused = FALSE;
        }
        return ();
    }

    // @dev Modifier to make a function callable only when the contract is paused.
    func when_paused{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        let (is_paused) = Poap_pausable_paused.read();
        with_attr error_message("Poap requires to be paused") {
            assert is_paused = TRUE;
        }
        return ();
    }

    // @dev called by the owner to pause, triggers stopped state
    func pause{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        PoapRoles.only_admin();
        when_not_paused();
        Poap_pausable_paused.write(TRUE);
        let message_sender = get_caller_address();
        Paused.emit(message_sender);
        return ();
    }

    // @dev called by the owner to unpause, returns to normal state
    func unpause{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
        PoapRoles.only_admin();
        when_not_paused();
        Poap_pausable_paused.write(FALSE);
        let message_sender = get_caller_address();
        Unpaused.emit(message_sender);
        return ();
    }
}
