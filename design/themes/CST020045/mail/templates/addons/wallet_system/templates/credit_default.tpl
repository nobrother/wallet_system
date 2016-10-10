{__("dear")} {$wallet_data.user_name},<br /><br />

{__("your_wallet_credited_with_amount")}<b>{include file="common/price.tpl" value=$wallet_data.amount}</b>
{if $wallet_data.source == 'refund_rma'}
{__("regardeing_return_request_no")}: <b>{$wallet_data.source_id}</b>
{/if}
{if $wallet_data.source == 'recharge'}
{__("regardeing_order_no")}: <b>{$wallet_data.source_id}</b>
{/if}
<br><br>
<small>
{if $wallet_data.source == 'refund_rma'}
<strong>{__("credit_source")} </strong>: {__("refund")}<br /><br />
{/if}
{if $wallet_data.source == 'recharge'}
<strong>{__("credit_source")} </strong>: {__("recharge")}<br /><br />
{/if}

<strong>{__("credit_wallet_amount")} </strong>: {include file="common/price.tpl" value=$wallet_data.amount}<br /><br />
<strong>{__("total_wallet_amount")}</strong> : {include file="common/price.tpl" value=$wallet_data.total_cash}<br /><br /></small>