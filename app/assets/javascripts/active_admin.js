//= require active_admin/base
//= require tiny_mce/jquery.tinymce
//= require jquery
//= require jquery-ui

$(document).ready(function() {
  load_editors();

  if($('body').hasClass('browse')){
    // Remove admin interface for /admin/images/browse (for TinyMCE image browser)
    $('body.browse.admin_a #header, #title_bar, #footer').hide();
    $('body.browse.admin_images #active_admin_content').css('padding', '0px');
    $('body.browse.admin_images a').click(returnImgURL);
    $.getScript("/assets/tiny_mce/tiny_mce_popup.js");
  }
  make_pages_sortable();
  make_dc_sortable();
  init_page_preview();
  collapse_additional_options();
});


function serializePages(){
  var pageIds = $.makeArray(
    $("#pages .page-col").map(function(){
      return $(this).data("id");
    })
  );
  return {ids: pageIds};
};
function make_pages_sortable(){
  $("#pages tbody").sortable({
    update: function(){
      $.ajax({
        url: "/admin/pages/sort",
        type: 'post',
        data: serializePages(),
        complete: function(){
          $(".paginated_collection").effect("highlight");
        }
      });
    }
  });
}
function serializedcategories(){
  var pageIds = $.makeArray(
    $("#document_categories .dc-col").map(function(){
      return $(this).data("id");
    })
  );
  return {ids: pageIds};
};
function make_dc_sortable(){
  $("#document_categories tbody").sortable({
    update: function(){
      $.ajax({
        url: "/admin/document_categories/sort",
        type: 'post',
        data: serializedcategories(),
        complete: function(){
          $(".paginated_collection").effect("highlight");
        }
      });
    }
  });
}

function collapse_additional_options(){
  $(".additional-options legend span").html("<a href='$'>"+$(".additional-options legend span").html()+"</a>");
  $(".additional-options ol").slideUp();
  $(".additional-options legend span").click(function(e){
    e.preventDefault();
    $(".additional-options ol").slideToggle();
  });
}

//http://www.tinymce.com/wiki.php/How-to_implement_a_custom_file_browser
function myFileBrowser (field_name, url, type, win) {
  /* If you work with sessions in PHP and your client doesn't accept cookies you might need to carry
     the session name and session ID in the request string (can look like this: "?PHPSESSID=88p0n70s9dsknra96qhuk6etm5").
     These lines of code extract the necessary parameters and add them back to the filebrowser URL again. */

  var cmsURL = "/admin/assets?order=id_desc&page=1&scope=images"//window.location.toString();    // script URL - use an absolute path!
  if (cmsURL.indexOf("?") < 0) {
      //add the type as the only query parameter
      cmsURL = cmsURL + "?type=" + type;
  }
  else {
      //add the type as an additional query parameter
      // (PHP session ID is now included if there is one at all)
      cmsURL = cmsURL + "&type=" + type;
  }

  tinyMCE.activeEditor.windowManager.open({
      file : cmsURL,
      title : 'My File Browser',
      width : 450,  // Your dimensions may differ - toy around with them!
      height : 400,
      resizable : "yes",
      inline : "yes",  // This parameter only has an effect if you use the inlinepopups plugin!
      close_previous : "no"
  }, {
      window : win,
      input : field_name
  });

  return false;
}

function load_editors(){
  $('#page_content, #location_content, #testimonial_content, #press_release_content').tinymce({
			// Location of TinyMCE script
      script_url : '/assets/tiny_mce/tiny_mce.js',

			// General options
			theme : "advanced",
			theme_advanced_resizing : true,
			relative_urls:true,
			width: "75%",
			plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,advlist",

			// Theme options
			theme_advanced_buttons1 : "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,formatselect,file_browser_callback",
			theme_advanced_buttons2 : "forecolor,backcolor,bullist,numlist,outdent,indent,blockquote,link,unlink,anchor,image,|,cut,copy,paste,pastetext,pasteword,|,search,replace,|,undo,redo,|,cleanup,code",
			theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,iespell,media,advhr,|,ltr,rtl,|,fullscreen",
			theme_advanced_toolbar_location : "top",
			theme_advanced_toolbar_align : "left",
			theme_advanced_statusbar_location : "bottom",
			theme_advanced_resizing : true,

			// Example content CSS (should be your site CSS)
			//content_css : "css/content.css",

			// Drop lists for link/image/media/template dialogs
			template_external_list_url : "lists/template_list.js",
			external_link_list_url : "lists/link_list.js",
			//external_image_list_url : "lists/image_list.js",
			media_external_list_url : "lists/media_list.js",

      file_browser_callback : 'myFileBrowser',

			// Replace values for the template plugin
			template_replace_values : {
				username : "Some User",
				staffid : "991234"
			}
		});
}

function returnImgURL(e){
  e.preventDefault();
  var URL = $(this).attr('href');
  var win = tinyMCEPopup.getWindowArg("window");

  // insert information now
  win.document.getElementById(tinyMCEPopup.getWindowArg("input")).value = URL;

  // for image browsers: update image dimensions
  if (win.getImageData) win.getImageData();

  // close popup window
  tinyMCEPopup.close();
}

function init_page_preview(){
  //Only do preview on Edit pages. on NEW pages, there's page children problems (unless I can somehow build them)
  // Create a new "preview" button
  $('form#page_edit .buttons ol li:eq(0)').clone().addClass("preview").appendTo($('form#page_edit .buttons ol'));
  $('form#page_edit .buttons ol li:last input').attr("value", "Preview")
  // Click Preview and open the form in a new window
  $('form#page_edit .buttons ol li:last input').click(function(){
    $('form#page_edit').attr("action", $('form#page_edit').attr("action").replace("admin/pages", "preview"));
    $('form#page_edit').attr("target", "_blank");
  });
  // Click Update and have it update the page
  $('form#page_edit .buttons ol li:first input').click(function(){
    $('form#page_edit').attr("action", $('form#page_edit').attr("action").replace("preview", "admin/pages"));
    $('form#page_edit').attr("target", "_self");
  });

  
}