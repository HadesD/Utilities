var list_view = document.querySelector("[data-testid='list_view']");

if (!list_view)
{
	throw "err";
}

var msgList = list_view.querySelectorAll('[data-testid="messenger_thread_list_row"]');

if (!msgList)
{
	throw "err";
}


