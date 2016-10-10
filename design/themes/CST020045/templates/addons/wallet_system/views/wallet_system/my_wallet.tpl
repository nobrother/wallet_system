<div class="ty-wallet-my_wallet {if $enable_transfer=="N"}no-transfer{/if} {if $enable_top_up=="N"}no-top-up{/if}">

    <div class="ty-fullwidth-banner">
		{include file="addons/wallet_system/views/wallet_system/wallet-balance.tpl" value=$total_cash label="CURRENT BALANCE:"}
		{if $enable_top_up=="Y" || $enable_transfer=="Y"}
		<div class="ty-action-buttons ty-items-distribute">
            {if $enable_top_up=="Y"}
			<a data-scroll-to="#top-up" class="btn btn-outline-only" id="btn-nav-top-up">TOP UP</a>
            {/if}
            
			{if $enable_transfer=="Y"}
			<a data-scroll-to="#transfer" class="btn btn-outline-only" id="btn-nav-transfer">TRANSFER</a>
			{/if}
            
			<a data-scroll-to="#transaction" class="btn btn-outline-only" id="btn-nav-transaction">TRANSACTION</a>            
		</div>
        {/if}
	</div>
	
	<!-- Actions block -->
	<div class="container-fluid ty-wallet-actions">
		<div class="row">
		
			<!-- Top up block -->
            {if $enable_top_up=="Y"}
			<div class="span8">
			<a class="anchor" id="top-up">&nbsp;</a>
				<form action="{"wallet_system.cash_add_wallet"|fn_url}" method="post" name="my_wallet_add_cash">
					<div class="ty-wallet-action-card" id="action-top-up">
						<div class="card-header">TOP UP</div>
						<div class="card-body">
							{include file="addons/wallet_system/views/wallet_system/wallet-balance.tpl" value=$total_cash}
						</div>
						<div class="card-footer">
							<div class="row">
								<div class="span8">
									<input type="number" 
										name="wallet_system[recharge_amount]" 
										id="this_wallet_recharge_amount" 
										class="ty-input-text" 
										placeholder="Enter your money amount"
										step="0.01"
										required
										value="{if $current_cash_to_add}{$current_cash_to_add}{/if}">
								</div>
								<div class="span8">
									<button class="btn btn-default" type="submit" name="wallet_submit" id="submit-top-up">TOP UP</button>
								</div>
							</div>
						</div>
					</div>
					
					
					<input type="text" 
								name="wallet_system[total_cash]" 
								id="wallet_total_cash" 
								class="ty-input-text hidden" 
								value="{$total_cash}">
				</form>
			</div><!-- // Top up block -->
			{/if}
            
			{if $enable_transfer=="Y"}
			<!-- Transfer block -->
			<div class="span8">
				<a class="anchor" id="transfer">&nbsp;</a>
				<form action="{"wallet_system.create_transfer"|fn_url}" method="post" name="my_wallet_create_transfer">
					<div class="ty-wallet-action-card" id="action-transfer">
						<div class="card-header">TRANSFER</div>
						
						<div class="card-body">
							<div class="title">Enter payee e-mail address</div>
							<input type="email" 
										name="wallet_transfer_system[transfer_email]" 
										id="this_wallet_enter_email" 
										class="ty-input-text" 
										required
										value="{$transfer_email}">
						</div>
						
						<div class="card-footer">
							<div class="row">
								<div class="span8">
									<input type="number" 
										name="wallet_transfer_system[transfer_amount]" 
										placeholder="Enter your money amount"
										id="this_wallet_enter_amount" 
										class="ty-input-text" value="{$transfer_amount}" 
										step="0.01"
										required>
								</div>
								<div class="span8">
									<button class="btn btn-default" type="submit" name="wallet_submit" id="submit-transfer">TRANSFER</button>
								</div>
							</div>
						</div>
					</div>
					
					
					<input type="text" 
								name="wallet_system[total_cash]" 
								id="wallet_total_cash" 
								class="ty-input-text hidden" 
								value="{$total_cash}">
				</form>
			</div><!-- // Transfer block -->
			{/if}
			
		</div><!-- ROW -->
		<a class="anchor" id="transaction">&nbsp;</a>
	</div><!-- // Actions block -->
	
	
	<!-- Transaction block -->
	<div class="container-fluid ty-wallet-transaction">
		
		<div class="header">
			TRANSACTION HISTORY
		</div>
		{include file="addons/wallet_system/views/wallet_system/wallet_transactions.tpl"}
	</div>
</div>