%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

const PK1 = 11111;
const PK2 = 22222;
const PK3 = 33333;
const PK4 = 44444;
const PK5 = 55555;

const NAME = 0x706f61705f6e616d65;
const SYMBOL = 0x706f61705f73796d626f6c;
const URI_LEN = 17;
const ADMINS_LEN = 3;

struct Addresses {
    poap: felt,
    admin1: felt,
    admin2: felt,
    admin3: felt,
    minter: felt,
    user: felt,
}

func deploy{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> Addresses {
    alloc_locals;

    local contracts: Addresses;

    %{
        declared = declare("lib/cairo_contracts/src/openzeppelin/account/presets/Account.cairo")

        prepared = prepare(declared, [ids.PK1])
        deploy(prepared)
        ids.contracts.admin1 = prepared.contract_address

        prepared = prepare(declared, [ids.PK2])
        deploy(prepared)
        ids.contracts.admin2 = prepared.contract_address

        prepared = prepare(declared, [ids.PK3])
        deploy(prepared)
        ids.contracts.admin3 = prepared.contract_address

        prepared = prepare(declared, [ids.PK4])
        deploy(prepared)
        ids.contracts.minter = prepared.contract_address

        prepared = prepare(declared, [ids.PK5])
        deploy(prepared)
        ids.contracts.user = prepared.contract_address

        declared = declare("./src/poap/Poap.cairo")
        prepared = prepare(declared, [ids.NAME, ids.SYMBOL, ids.URI_LEN, 104, 116, 116, 112, 115, 58, 47, 47, 112, 111, 97, 112, 46, 120, 121, 122, 47, ids.ADMINS_LEN, ids.contracts.admin1, ids.contracts.admin2, ids.contracts.admin3])
        deploy(prepared)
        ids.contracts.poap = prepared.contract_address

        print(f"poap address: {ids.contracts.poap}")
        print(f"admin1 address: {ids.contracts.admin1}")
        print(f"admin2 address: {ids.contracts.admin2}")
        print(f"admin3 address: {ids.contracts.admin3}")
        print(f"minter address: {ids.contracts.minter}")
        print(f"user address: {ids.contracts.user}")
    %}
    return contracts;
}
