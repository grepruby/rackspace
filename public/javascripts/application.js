/**
 * When the app start, we load differents things that are necesary, in the following block the app loads watermarks, validations, click, etc
 */

jQuery(function() {


	if (BrowserDetect.browser == "Safari"){jQuery('#user_email').css("line-height","0px");jQuery('#user_password').css("line-height","0px");jQuery("#fieldForgotPassword").css("line-height","0px");jQuery("#fieldForgotConfirmPassword").css("line-height","0px");}
	if ((BrowserDetect.OS == "Mac") && (BrowserDetect.browser == "Firefox")){jQuery('#special_photo').attr("size","24");jQuery('#restaurant_photo').attr("size","24");}
	/*this funtion prevent if the timeout session happen, devise don't redirect, so this cath up the ajax error and redirect*/
	jQuery(document).ajaxError( function(e, xhr, options){if("401" == xhr.status) jQuery(location).attr('href','/users/sign_in');});
	/*****************************************************************************************************************/
	//User menu, on the top right header
	jQuery('#flat').menu({content : $('#flat').next().html(),showSpeed : 400});
	/*****************************************************************************************************************/
	//Sign up process, all steps
	jQuery("#first_name").watermark("Enter First Name");
	jQuery("#last_name").watermark("Enter Last Name");
	jQuery("#username").watermark("Enter Email Address");
	jQuery("#username_confirmation").watermark("Confirm Email Address");
	jQuery("#new_username").watermark("New Email Address");
	jQuery("#new_username_confirmation").watermark("Retype New Email Address");
	jQuery("#current_password").watermark("Enter Current Password");
	jQuery("#password").watermark("Enter Password");
	jQuery("#password_confirmation").watermark("Confirm Password");
	jQuery("#newPassword").watermark("New Password");
	jQuery("#newPassword_confirmation").watermark("Confirm New Password");
	jQuery("#user_email").watermark("Enter Email Address");
	jQuery("#user_password").watermark("Enter Password");
	jQuery("#fullname").watermark("Full Name On Card");
	jQuery("#card_number").watermark("Card Number");
	jQuery("#cvc").watermark("CVC");
	jQuery("#billing_address_1").watermark("Billing Address Line 1");
	jQuery("#billing_address_2").watermark("Billing Address Line 2");
	jQuery("#city").watermark("City");
	jQuery("#zip").watermark("Zip Code");
	//forgot password 
	jQuery("#fieldForgotPassword").watermark("New Password");
	jQuery("#fieldForgotConfirmPassword").watermark("Confirm New Pasword");
	/*****************************************************************************************************************/
	//Restaurant Info, all about the My info tab, remeber also the my_info.js with the ajax call
	jQuery("#food_categories").multiselect({header : false,noneSelectedText : 'Select Food Categories',selectedText : "# of # Food Categories selected",minWidth : 341});
	jQuery("#restaurant_name").watermark("Restaurant Name");
	jQuery("#website_url").watermark("Website URL");
	jQuery("#menu_url").watermark("Menu URL");
	jQuery("#restaurant_phone_number").watermark("Phone Number");
	jQuery("#restaurant_address").watermark("Address");
	jQuery("#video_url").watermark("Paste YouTube URL Here");	
	//This method is repeated in my_info.js.erb
	jQuery('#previewBtn').click(function() {var status = jQuery("#designForm").valid();if (status === true){jQuery('#to_save').val('false');showSpinner('iphone');}else {jQuery("#showErrors").click();}});
	//This method is repeated in my_info.js.erb
	jQuery('#saveBtn').click(function() {var status = jQuery("#designForm").valid();if (status === true){jQuery('#to_save').val(true);showSpinner('iphone');}else {jQuery("#showErrors").click();}});
	/*****************************************************************************************************************/
	//Special section
	setWatermarksForSpecial();
	jQuery('#special0Btn').click(function() {if (jQuery("#specialForm").valid()){showSpinner('iphone');jQuery('#formAction').val('0');jQuery("#specialForm").validate().cancelSubmit = true;}else{ jQuery("#showErrors").click();}});
	jQuery('#special1Btn').click(function() {if (jQuery("#specialForm").valid()){showSpinner('iphone');jQuery('#formAction').val('1');jQuery("#specialForm").validate().cancelSubmit = true;}else{ jQuery("#showErrors").click();}});
	jQuery('#special2Btn').click(function() {if (jQuery("#specialForm").valid()){showSpinner('iphone');jQuery('#formAction').val('2');jQuery("#specialForm").validate().cancelSubmit = true;}else{ jQuery("#showErrors").click();}});
	jQuery('#special3Btn').click(function() {if (jQuery("#specialForm").valid()){showSpinner('iphone');jQuery('#formAction').val('3');jQuery("#specialForm").validate().cancelSubmit = true;}else{ jQuery("#showErrors").click();}});
	jQuery('#special4Btn').click(function() {if (jQuery("#specialForm").valid()){showSpinner('iphone');jQuery('#formAction').val('4');jQuery("#specialForm").validate().cancelSubmit = true;}else{ jQuery("#showErrors").click();}});
	jQuery('#addSpecialBtn').click(function() {if (jQuery("#specialForm").valid()){showSpinner('iphone');jQuery('#formAction').val('addSpecial');jQuery("#addSpecialBtn").attr('disabled');}else{ jQuery("#showErrors").click();}});
	jQuery('#previewSpecialBtn').click(function() {if (jQuery("#specialForm").valid()){showSpinner('iphone');jQuery('#formAction').val('previewSpecial');jQuery('#previewSpecialBtn').attr('disabled');}else{ jQuery("#showErrors").click();}});
	jQuery('#saveSpecialBtn').click(function() {jQuery("#specialForm").validate().cancelSubmit = false; if (jQuery("#specialForm").valid()){showSpinner('iphone');jQuery('#formAction').val('saveSpecial');jQuery('#saveSpecialBtn').attr('disabled');}else{jQuery("#showErrors").click();}});
	jQuery("#special_start_date").datepicker({dateFormat:"mm/dd/yy"});
	jQuery("#special_end_date").datepicker({dateFormat:"mm/dd/yy"});
	/*****************************************************************************************************************/
	//This is for the errors pop up implement in the my info and specials tabs
	//This method is repeated in my_info.js.erb
	jQuery('#errorButtonOk').click(function() {jQuery.fancybox.close();jQuery.watermark.showAll();jQuery('#errorContent').empty();if ((BrowserDetect.OS == "Mac") && (BrowserDetect.browser == "Firefox")){jQuery('#special_photo').replaceWith("<input id='special_photo' class='arial16pt808080' type='file' size='24' name='special_photo'>");}else{jQuery('#special_photo').replaceWith("<input id='special_photo' class='arial16pt808080' type='file' size='34' name='special_photo'>");}});
	//This method is repeated in my_info.js.erb
	jQuery("a#showErrors").fancybox({'hideOnContentClick': false,'hideOnOverlayClick': false,'padding': 0,'showCloseButton': false});
	jQuery("a#showDeleteConfirmationPopup").fancybox({'hideOnContentClick': false,'hideOnOverlayClick': false,'padding': 0,'showCloseButton': false});
	jQuery('#confirmDeleteBtn').click(function() {showSpinner('iphone');jQuery('#deleteSpecialBtn').attr('disabled');jQuery("#deleteActionForm").submit();jQuery.fancybox.close();});
	jQuery('#confirmDeleteCancelBtn').click(function() {jQuery.fancybox.close();});
	jQuery("a#showTermsPopup").fancybox({'hideOnContentClick': false,'hideOnOverlayClick': false,'padding': 0,'showCloseButton': false});
	jQuery("#termsPopUpBtn").click(function(){jQuery("#showTermsPopup").click();})	
	jQuery("a#showSendNotificationsConfirmationPopup").fancybox({'hideOnContentClick': false,'hideOnOverlayClick': false,'padding': 0,'showCloseButton': false});
	jQuery('#sendNotificationOkBtn').click(function() {jQuery('#formAction').val('sendUpdateNotifications');jQuery("#specialForm").validate().cancelSubmit = true;jQuery("#specialForm").submit();jQuery.fancybox.close();});
	jQuery('#sendNotificationCancelBtn').click(function() {hideSpinner('iphone');jQuery('#formAction').val('');jQuery.fancybox.close();});
	jQuery("a#showCancelSubscriptionConfirmationPopup").fancybox({'hideOnContentClick': false,'hideOnOverlayClick': false,'padding': 0,'showCloseButton': false});
	jQuery('#yesCancelSubscriptionBtn').click(function() {jQuery('#cancelSubscription').val(true);jQuery("#subscriptionForm").submit();jQuery.fancybox.close();});
	jQuery('#noCancelSubscriptionBtn').click(function() {jQuery.fancybox.close();});
	jQuery('#cancelSubscriptionBtn').click(function() {jQuery("#showCancelSubscriptionConfirmationPopup").click();});
	jQuery("#accordion").find("h3").click(function() {jQuery(this).find("> .ui-icon").toggleClass("ui_accordion_open_icon ui_accordion_open_close").end().next().slideToggle();return false;});
	jQuery("#accordionSettings").find("div.ui-accordion-actions").click(function() {var content = jQuery(this).parent().next();if(content.css('display') == 'none'){jQuery(this).html("Cancel");jQuery(this).prev().css("width", 395);jQuery(this).next().show();}else{jQuery(this).html("Edit");jQuery(this).prev().css("width", 460);jQuery(this).next().hide();}jQuery(this).parent().next().slideToggle("slow");});
	
	
});

//Enable or disabled the agree terms in the step 3 for sign up process
function enableBtn() {if(jQuery("#agree").is(':checked')) jQuery("#signupBtn").removeAttr('disabled'); else jQuery("#signupBtn").attr("disabled", "disabled")}

//Functions to handle the spinner control in the my infor tab and specials tab
var spinner;
function showSpinner(targetName) {if(spinner == null) { var opts = {lines : 12,length : 25,width : 8,radius : 35,color : '#FFFFFF',speed : 0.7,trail : 60,shadow : true};var target = document.getElementById(targetName);jQuery("#" + targetName).css({ opacity : 0.5 });spinner = new Spinner(opts).spin(target)}}
function hideSpinner(targetName) {if(spinner != null) {jQuery("#" + targetName).css({opacity : 1});spinner.stop();spinner = null}}
/*Function to refresh the special fields*/
function setSpecialFormFields(num,title, details, startDate, endDate, tags){jQuery('#specialNumbTitle').html('Featured Special ' + num);jQuery('#special_title').val(decodeSpecialCharacters(title));jQuery('#special_details').val(decodeSpecialCharacters(details));jQuery('#special_start_date').val(startDate);jQuery('#special_end_date').val(endDate);jQuery('#special_tags').val(tags);}
/* Function to decode the character quotes and ampersand */
function decodeSpecialCharacters(text){return text.replace( /\&amp;/g, '&' ).replace( /\&quot;/g, '"' );}
/*Handler for the click action on the back left arrow on the tutorial*/
function nextClickOnTutorial() {jQuery("#tutorialPage1").hide();jQuery("#tutorialPage2").show();}
/*Handler for the click action on the back left arrow on the tutorial*/
function backClickOnTutorial() {jQuery("#tutorialPage2").hide();jQuery("#tutorialPage1").show();}
/*Set the watermarks for the sepecial form */
function setWatermarksForSpecial() {jQuery("#special_title").watermark("Featured Special Title");jQuery("#special_details").watermark("Deal Details");jQuery("#special_start_date").watermark("MM/DD/YYYY");jQuery("#special_end_date").watermark("MM/DD/YYYY");jQuery("#special_tags").watermark("Add Tags separated by commas");}
/* Identify the Browser and the OS */
var BrowserDetect = {init: function () {this.browser = this.searchString(this.dataBrowser) || "An unknown browser";this.version = this.searchVersion(navigator.userAgent) || this.searchVersion(navigator.appVersion) || "an unknown version";this.OS = this.searchString(this.dataOS) || "an unknown OS";},
	searchString: function (data) {for (var i=0;i<data.length;i++)	{var dataString = data[i].string;var dataProp = data[i].prop;this.versionSearchString = data[i].versionSearch || data[i].identity;if (dataString) {if (dataString.indexOf(data[i].subString) != -1)	return data[i].identity;}else if (dataProp)	return data[i].identity;}},
	searchVersion: function (dataString) {var index = dataString.indexOf(this.versionSearchString);if (index == -1) return;return parseFloat(dataString.substring(index+this.versionSearchString.length+1));},
	dataBrowser: [{string: navigator.userAgent,subString: "Chrome",identity: "Chrome"},{string: navigator.userAgent,subString: "OmniWeb",versionSearch: "OmniWeb/",identity: "OmniWeb"},{string: navigator.vendor,subString: "Apple",identity: "Safari",versionSearch: "Version"},{prop: window.opera,identity: "Opera",versionSearch: "Version"},{string: navigator.vendor,subString: "iCab",identity: "iCab"},{string: navigator.vendor,subString: "KDE",identity: "Konqueror"},{string: navigator.userAgent,subString: "Firefox",identity: "Firefox"},{string: navigator.vendor,subString: "Camino",identity: "Camino"},{string: navigator.userAgent,subString: "Netscape",identity: "Netscape"},{string: navigator.userAgent,	subString: "MSIE",identity: "Explorer",versionSearch: "MSIE"},{string: navigator.userAgent,subString: "Gecko",identity: "Mozilla",versionSearch: "rv"},{/*for older Netscapes (4-)*/string: navigator.userAgent,subString: "Mozilla",identity: "Netscape",versionSearch: "Mozilla"}],
	dataOS : [{string: navigator.platform,subString: "Win",	identity: "Windows"	},{string: navigator.platform,subString: "Mac",identity: "Mac"},{string: navigator.userAgent,subString: "iPhone",identity: "iPhone/iPod"},{string: navigator.platform,subString: "Linux",identity: "Linux"}]};
BrowserDetect.init();
