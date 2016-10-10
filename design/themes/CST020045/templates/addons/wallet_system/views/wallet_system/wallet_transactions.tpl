<div class="ty-wallet-credit cm-pagination cm-history cm-pagination-button">
    <form action="{""|fn_url}" method="post" name="wallet_transaction_form">
        {assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}
        {assign var="c_icon" value="<i class=\"exicon-`$search.sort_order_rev`\"></i>"}
        {assign var="c_dummy" value="<i class=\"exicon-dummy\"></i>"}
        {include file="common/pagination.tpl"}
        <table class="ty-table ty-wallet-credit__table">
            <thead>    
                <tr>
                    <th style="width: 0%">Credit ID / Debit ID</a></th>
                    <th style="width: 0%">Transaction Type</th>
                    <th style="width: 0%">Reference ID</th>
                    <th style="width: 0%">{__("credit")}</th>
                    <th style="width: 0%">{__("debit")}</th>
                    <th style="width: 0%">{__("total_cash")}</th>
                    <th style="width: 0%">{__("timestamp")}</th>
                </tr>
            </thead>
            <tbody>
            {foreach from=$wallet_transactions item="transaction"}
                {assign var=extra_info value=unserialize($transaction.extra_info)}
                {assign var=wallet_user_email value=$transaction.wallet_id|fn_wallet_system_get_wallet_user_email_id}
                <tr>
                {if isset($transaction.credit_id)}
                    <td>{$transaction.credit_id}{include file="common/tooltip.tpl" tooltip=$transaction.refund_reason}</td>
                  
                    <td>
                        <div class="item-transaction-type">
                            {__("credit")}
                            {if $transaction.source == 'recharge'}
                                {__("recharge")}
                            {elseif $transaction.source == 'transfer'}
                                {__("transfer")}
                            {elseif $transaction.source == 'credit_by_admin'}
                                by Red Deals
                            {else}
                                {__("refund")}
                            {/if}
                        </div>
                    </td>
                    {if !empty($transaction.source_id)}
                    <td>
                        <div class="item-ref-id">
                            {if $transaction.source eq 'refund_rma'}
                                {__("return_id")}
                                <a class="highlight-red" href="?dispatch=rma.details&return_id={$transaction.source_id}">#{$transaction.source_id}</a>
                            {else}
                                {__("order_id")}
                                <a class="highlight-red" href="?dispatch=orders.details&order_id={$transaction.source_id}">#{$transaction.source_id}</a>
                            {/if}
                        </div>
                    </td>
                    {else}
                    <td>
                        {if isset($extra_info.sender_email)}
                            From: {$extra_info.sender_email}{else}{$wallet_user_email}
                        {/if}
                    </td>
                    {/if}
                    <td><div class="ty-price">{include file="common/price.tpl" value=$transaction.credit_amount class="ty-price-num"}</div></td>
                    <td>-</td>
                    <td><div class="ty-price">{include file="common/price.tpl" value=$transaction.total_amount class="ty-price-num"}</div></td>
                    <td>{$transaction.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>

                {else if isset($transaction.debit_id)} 
                
                    <td class="row-status">
                        {$transaction.debit_id}
                        {if !empty($transaction.debit_reason)}
                            {include file="common/tooltip.tpl" tooltip=$transaction.debit_reason}
                        {/if}
                    </td>
                 
                    <td class="row-status">
                        <div class="item-transaction-type">
                            {__("debit")}
                            {if $transaction.source == 'debit_by_admin'}
                                by Red Deals
                            {/if}
                        </div>
                    </td>
                        
                    {if !empty($transaction.order_id)}
                    <td class="row-status">
                        <div class="item-ref-id">
                            {__("order_id")}
                            <a class="highlight-red" href="?dispatch=orders.details&order_id={$transaction.order_id}">#{$transaction.order_id}</a>
                        </div>
                    </td>
                    {else}
                    <td class="row-status">
                        <div class="item-ref-id">
                            {if !empty($extra_info.reciever_email)}
                                To: {$extra_info.reciever_email}
                            {else}
                                {$wallet_user_email}
                            {/if}
                        </div>
                    </td>
                    {/if}
                    <td class="row-status">-</td> 
                    <td class="row-status"><div class="ty-price">{include file="common/price.tpl" value=$transaction.debit_amount class="ty-price-num"}</div></td> 
                    <td class="row-status"><div class="ty-price">{include file="common/price.tpl" value=$transaction.remain_amoun class="ty-price-num"}</div></td>
                    <td class="row-status"> {$transaction.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td> 
                {/if}       
                </tr>
            {foreachelse}
                <tr class="ty-table__no-items">
                    <td colspan="7"><p class="ty-no-items">{__("no_data")}</p></td>
                </tr>
            {/foreach}
            </tbody>
        </table>
        {include file="common/pagination.tpl"}
    </form>
 {capture name="mainbox_title"}{__("wallet_transactions")}{/capture}
</div>