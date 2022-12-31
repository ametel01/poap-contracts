%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

// @title Pausable
// @dev Base contract which allows children to implement an emergency stop mechanism.

@event
func Paused(account: felt) {
}

@event
func Unpaused(account: felt) {
}
