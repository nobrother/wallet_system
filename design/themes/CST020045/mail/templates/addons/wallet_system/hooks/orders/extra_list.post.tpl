{if isset($order_info.gift_certificates)}
{else}
     
        {if empty($order_info.products)}
            <tr>
                    <td style="padding: 5px 10px; background-color: #ffffff; font-size: 12px; font-family: Arial;">
                        {__("wallet_recharge")}
                    </td>
                    <td style="padding: 5px 10px; background-color: #ffffff; text-align: center; font-size: 12px; font-family: Arial;">1</td>
                    <td style="padding: 5px 10px; background-color: #ffffff; text-align: right; font-size: 12px; font-family: Arial;">{include file="common/price.tpl" value=$order_info.display_subtotal}</td>
                    {if $order_info.use_discount}
                    <td style="padding: 5px 10px; background-color: #ffffff; text-align: right; font-size: 12px; font-family: Arial;">{if $oi.extra.discount|floatval}{include file="common/price.tpl" value=$oi.extra.discount}{else}&nbsp;-&nbsp;{/if}</td>
                    {/if}
                    {if $order_info.taxes && $settings.General.tax_calculation != "subtotal"}
                        <td style="padding: 5px 10px; background-color: #ffffff; text-align: right; font-size: 12px; font-family: Arial;">{if $oi.tax_value}{include file="common/price.tpl" value=$oi.tax_value}{else}&nbsp;-&nbsp;{/if}</td>
                    {/if}
        
                    <td style="padding: 5px 10px; background-color: #ffffff; text-align: right; white-space: nowrap; font-size: 12px; font-family: Arial;"><b>{include file="common/price.tpl" value=$order_info.display_subtotal}</b>&nbsp;</td>
                </tr>
        {/if}            
{/if}