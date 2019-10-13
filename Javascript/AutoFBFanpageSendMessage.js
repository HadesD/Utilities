var list_view = document.querySelector('[data-testid="list_view"]');

if (!list_view)
{
	throw "err";
}

// console.log(list_view);

function getAllMsgThread()
{
	return list_view.querySelectorAll('[data-testid="messenger_thread_list_row"]');
}

function getSelectedMsgIndex()
{
	var msgList = getAllMsgThread();
	for (var i in msgList)
	{
		var msg = msgList[i];
		if (msg && msg.classList && msg.classList.contains('_2tms'))
		{
			return i;
		}
	}
	
	return -1;
}

var selected = getSelectedMsgIndex();

if (selected === -1)
{
	throw "err";
}

// console.log(selected);

var msgTxtBox = document.querySelector('[data-testid="inbox_composer_text_input"]');

if (!msgTxtBox)
{
	throw "err";
}

var sendBtnWrap = document.querySelector('[data-testid="inbox_coomposer_send"]');

if (!sendBtnWrap)
{
	throw "err";
}

sendBtnWrap.classList.remove('hidden_elem');

console.log(sendBtnWrap);

var sendBtn = sendBtnWrap.querySelector('button');

sendBtn.removeAttribute('disabled');
