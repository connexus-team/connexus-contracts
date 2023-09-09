// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20Receiver {
    /**
     * @dev Whenever an {IERC20} amount is transferred to this contract from `from`, this function is called.
     *
     * It must return true to confirm the token transfer.
     * If false is returned the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC20Receiver.onERC20Received.selector`.
     */
    function onERC20Received(
        address from,
        uint256 amount
    ) external returns (bool);

    /* to use this code, put the following in your ERC-20 implementation:

    function _afterTokenTransfer(address from, address to, uint256 amount) internal override {
        if ( to.code.length > 0  && from != address(0) && to != address(0) ) {
            // token recipient is a contract, notify them
            try IERC20Receiver(to).onERC20Received(from, amount) returns (bool success) {
                require(success,"ERC-20 receipt rejected by destination of transfer");
            } catch {
                // the notification failed (maybe they don't implement the `IERC20Receiver` interface?)
                // we choose to ignore this case
            }
        }
    }

*/
}
