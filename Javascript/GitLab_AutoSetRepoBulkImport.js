const a = $0;
const trList = $0.getElementsByTagName('tr');
const trSize = trList.length;
for (let i = 0; i < trSize; i++) {
    const curTr = trList[i];
    const tdList = curTr.getElementsByTagName('td');
    const td2Btns = tdList[1].getElementsByTagName('button');
    if (!td2Btns.length) continue;
    const td1Txt = tdList[0].innerText.trim();
    const td2Input2 = tdList[1].getElementsByTagName('input')[1];
    const inptTxt = td2Input2.value.trim();
    for (let k = 1; k < td2Btns.length; k++) {
        const btn = td2Btns[k];
        const btnTxt = btn.innerText.trim();
        const fieldTxt = btnTxt + '/' + inptTxt;
        if (td1Txt !== fieldTxt) continue;
        console.log(td1Txt, fieldTxt);
        btn.click();
    }
}
