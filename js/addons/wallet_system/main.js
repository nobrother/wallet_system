;(function($){	
	
	$(function(){
		
		// Scroll to
		$('body').on('click', '[data-scroll-to]', function(e){
			e.preventDefault();
			var selector = $(e.target).data('scroll-to'),
				el = $(selector);
				
			if(el.length)
				$.scrollToElm(el);
			
		});
		
		// Target page
		var $page = $('.ty-wallet-my_wallet'),
			$navTopUp = $('#btn-nav-top-up'),
			$navTransfer = $('#btn-nav-transfer'),
			$navTransaction = $('#btn-nav-transaction'),
			$inputTopUpAmt = $('#this_wallet_recharge_amount'),
			$inputEmail = $('#this_wallet_enter_email'),
			$inputTransferAmt = $('#this_wallet_enter_amount'),
			$submitTopUp = $('#submit-top-up'),
			$submitTransfer = $('#submit-transfer'),
			oldPhTopUpAmt = $inputTopUpAmt.attr('placeholder'),
			oldPhEmail = $inputEmail.attr('placeholder'),
			oldPhTransferAmt = $inputTransferAmt.attr('placeholder');
		if($page.length === 0)
			return;
		
		// Active action
		$navTopUp.on('click', function(e){
			$page.removeClass('transfer-active')
				.addClass('top-up-active');
			
			// Classes
			$navTopUp.addClass('active');
			$navTransfer.removeClass('active');
			//$submitTopUp.addClass('active');
			//$submitTransfer.removeClass('active');			
			
			// Placeholder
			$inputTopUpAmt.attr('placeholder', 'Please fill in amount.').addClass('active');
			$inputEmail.attr('placeholder', oldPhEmail).removeClass('active');
			$inputTransferAmt.attr('placeholder', oldPhTransferAmt).removeClass('active');
			
			// Focus
			setTimeout(function(){
				$inputTopUpAmt.focus();
			}, 550);
		});
		$navTransfer.on('click', function(e){
			$page.removeClass('top-up-active')
				.addClass('transfer-active');
			
			// Classes
			$navTopUp.removeClass('active');
			$navTransfer.addClass('active');
			//$submitTopUp.removeClass('active');
			//$submitTransfer.addClass('active');
			
			// Placeholder
			$inputTopUpAmt.attr('placeholder', oldPhTopUpAmt).removeClass('active');
			$inputEmail.attr('placeholder', 'Please fill in recipient address.').addClass('active');
			$inputTransferAmt.attr('placeholder', 'Please fill in amount.').addClass('active');
			
			// Focus
			setTimeout(function(){
				$inputEmail.focus();
			}, 550);
		});
		$navTransaction.on('click', function(e){
			$page.removeClass('top-up-active transfer-active');
			
			// Classes
			$navTopUp.removeClass('active');
			$navTransfer.removeClass('active');
			//$submitTopUp.removeClass('active');
			//$submitTransfer.removeClass('active');
			
			// Placeholder
			$inputTopUpAmt.attr('placeholder', oldPhTopUpAmt).removeClass('active');
			$inputEmail.attr('placeholder', oldPhEmail).removeClass('active');
			$inputTransferAmt.attr('placeholder', oldPhTransferAmt).removeClass('active');
		});
		
		// Event: Become active when start fill up
		$inputTopUpAmt.on('keydown keyup blur', function(e){
			if($inputTopUpAmt.val())
				$submitTopUp.addClass('active');				
			else
				$submitTopUp.removeClass('active');			
		});
		$inputEmail.add($inputTransferAmt).on('keydown keyup blur', function(e){
			if($inputEmail.val() && $inputTransferAmt.val())
				$submitTransfer.addClass('active');
			else
				$submitTransfer.removeClass('active');			
		});
	});	
})(jQuery);