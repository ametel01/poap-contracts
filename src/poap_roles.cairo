%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
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
