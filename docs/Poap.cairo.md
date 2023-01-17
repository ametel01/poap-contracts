# View Functions

### name

`func name() -> (res: felt)`

Gets the token name.

Outputs
| Name | Type | Description |
|------|------|-------------|
| `res` | `felt` |    |

### symbol

`func symbol() -> (res: felt)`

Gets the token symbol.

Outputs
| Name | Type | Description |
|------|------|-------------|
| `res` | `felt` |    |

### ownerOf

`func ownerOf(tokenId: Uint256) -> (address: felt)`

Gets the owner of a specific token ID.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `tokenId` | `Uint256` |  |

Outputs
| Name | Type | Description |
|------|------|-------------|
| `address` | `felt` |    |

### tokenEvent

`func tokenEvent(tokenId: Uint256) -> (res: felt)`

Gets the ID of the event a token is associated to.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `tokenId` | `Uint256` |  |

Outputs
| Name | Type | Description |
|------|------|-------------|
| `res` | `felt` |    |

### tokenDetailsOfOwnerByIndex

`func tokenDetailsOfOwnerByIndex(owner: felt, index: Uint256) -> (tokenId: Uint256, eventId: felt)`

Gets the token ID at a given index of the tokens list of the requested owner.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `owner` | `felt` |  address owning the tokens list to be accessed.  |
| `index` | `Uint256` |  uint256 representing the index to be accessed of the requested tokens list.  |

Outputs
| Name | Type | Description |
|------|------|-------------|
| `tokenId` | `Uint256` |    |
| `eventId` | `felt` |    |

### tokenURI

`func tokenURI(tokenId: Uint256) -> (uri_len: felt, uri: felt*)`

Gets the token uri.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `tokenId` | `Uint256` |  |

Outputs
| Name | Type | Description |
|------|------|-------------|
| `uri_len` | `felt` |    |
| `uri` | `felt*` |    |

### paused

`func paused() -> (res: felt)`

Gets the state of the contract, if paused no mint or transfer will be allowed.

Outputs
| Name | Type | Description |
|------|------|-------------|
| `res` | `felt` |    |

### isEventMinter

`func isEventMinter(eventId: felt, address: felt) -> (res: felt)`

Gets the permission level of an address on a specific event.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `eventId` | `felt` |  the unique Id of the event we are quering for.#  |
| `address` | `felt` |  the address of the account we are quering for.  |

Outputs
| Name | Type | Description |
|------|------|-------------|
| `res` | `felt` |    |

# External Functions

### setBaseURI

`func setBaseURI(base_token_uri_len: felt, base_token_uri: felt*)`

Sets the base URI, in the format of 1 felt for each character of the URI.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `base_token_uri_len` | `felt` |  the number of felts composing the URI.  |
| `base_token_uri` | `felt*` |  a pointer to the first felt composing the URI.  |

### approve

`func approve(to: felt, tokenId: Uint256)`

Gives permission to to to transfer tokenId token to another account. The approval is cleared when the token is transferred.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `to` | `felt` |  the address that is approved to tranfer the token.  |
| `tokenId` | `Uint256` |  the unique ID of the token approved for the tranfer.  |

### setApprovalForAll

`func setApprovalForAll(to: felt, approved: felt)`

Approve or remove operator as an operator for the caller. Operators can call transferFrom or safeTransferFrom for any token owned by the caller.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `to` | `felt` |  the address the change of approval refers to.  |
| `approved` | `felt` |    |

### transferFrom

`func transferFrom(from_: felt, to: felt, tokenId: Uint256)`

Transfers tokenId token from from_ to to. The caller is responsible to confirm that to is capable of receiving NFTs or else they may be permanently lost.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `from_` | `felt` |  the current owner of the token.  |
| `to` | `felt` |  the address to which the token will be sent to.  |
| `tokenId` | `Uint256` |  the unique ID of the token to be transferred.  |

### mintToken

`func mintToken(eventId: felt, to: felt)`

Function to mint tokens

Inputs

| Name | Type | Description |
|------|------|-------------|
| `eventId` | `felt` |  EventId for the new token  |
| `to` | `felt` |  The address that will receive the minted tokens.  |

### mintTokenWithId

`func mintTokenWithId(eventId: felt, tokenId: Uint256, to: felt)`

Function that transfers a token with a spefic ID.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `eventId` | `felt` |  the unique ID of the event.  |
| `tokenId` | `Uint256` |  the unique ID of the token.  |
| `to` | `felt` |  the address to which the token will be tranferred.  |

### mintEventToManyUsers

`func mintEventToManyUsers(event_id: felt, to_len: felt, to: felt*)`

Function to mint tokens

Inputs

| Name | Type | Description |
|------|------|-------------|
| `event_id` | `felt` |    |
| `to_len` | `felt` |    |
| `to` | `felt*` |  The address that will receive the minted tokens.  |

### mintUserToManyEvents

`func mintUserToManyEvents(events_len: felt, events: felt*, to: felt)`

Function to mint tokens

Inputs

| Name | Type | Description |
|------|------|-------------|
| `events_len` | `felt` |    |
| `events` | `felt*` |    |
| `to` | `felt` |  The address that will receive the minted tokens.  |

### pause

`func pause()`

called by the owner to pause, triggers stopped state

### unpause

`func unpause()`

called by the owner to unpause, returns to normal state

### addAdmin

`func addAdmin(account: felt)`

Gives admin permissions to an account.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `account` | `felt` |  the address of the account to be given admin permissions.  |

### addEventMinter

`func addEventMinter(eventId: felt, account: felt)`

Gives event minter permissions to a specific event to an account.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `eventId` | `felt` |  the unique ID of the event.  |
| `account` | `felt` |  the address of the account to be given event minter permissions.  |

### removeEventMinter

`func removeEventMinter(eventId: felt, account: felt)`

Removes event minter permissions for a specific event to an account.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `eventId` | `felt` |  the unique ID of the event.  |
| `account` | `felt` |  the address of the account to be given event minter permissions.  |

### renounceEventMinter

`func renounceEventMinter(eventId: felt)`

Allows an event minter to renounce to minter permissions.

Inputs

| Name | Type | Description |
|------|------|-------------|
| `eventId` | `felt` |  the unique ID of the event.  |

### renounceAdmin

`func renounceAdmin()`

Allows an admin to renounce to admin permissions.

