 {hook name="orders:invoice"}
	{if $order_info.payment_id==6 && $order_info.wallet.used_cash>0}
		<table cellpadding="0" cellspacing="0" border="0" width="100%" style="direction: {$language_direction};">
		        <tr>
	                <td align="right">
		                <table border="0" style="direction: {$language_direction}; padding: 3px 0px 12px 0px;">
			              
			                <tr>
			                    <td style="text-align: right; white-space: nowrap; font: 15px Tahoma; text-align: right;">{__("un_paid_amount")}:&nbsp;</td>
			                    <td style="text-align: right; white-space: nowrap; font: 15px Tahoma; text-align: right;"><strong style="font: bold 17px Tahoma;">{include file="common/price.tpl" value=$order_info.total-$order_info.wallet.used_cash}</strong></td>
			                </tr>
			            </table>

		           </td>
		        </tr>
		</table>			
	{/if}         
 {/hook}