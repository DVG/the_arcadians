$("#discussion_posts_table").append("<%= escape_javascript(render(@post)) %>");
$("#post_body").val("");