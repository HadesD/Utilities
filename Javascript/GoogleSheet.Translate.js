function translateSheet() {
  var sheets = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = sheets.getSheetByName("DetailDesign");
  var range = sheet.getRange("A1:AG2000");
  var values = range.getValues();
  for (let rowI = 0; rowI < values.length; rowI++) {
    let row = values[rowI];
    for (let colI = 0; colI < row.length; colI++) {
      
      // if (rowI < 803) {
      // if (rowI !== 806) {
      //   continue;
      // }

      let col = row[colI];
      // Logger.log(col);
      if (!col) {
        continue;
      }

      if (!col.length || (col === '〇')) {
        continue;
      }

      if (col.match(/^[a-zA-Z0-9-_. ]+$/g)) {
        continue;
      }

      let toLang = "en_US";

      if (rowI >= 801) {
        if (col.indexOf('.') === -1) {
          toLang = "vi";
        }
      }

      let cell = sheet.getRange(rowI + 1, colI + 1);
      let hasLink = false;
      cell.getRichTextValue().getRuns().forEach(v => {
        if (hasLink) {
          return;
        }
        //Logger.log(v.getLinkUrl());
        hasLink = v.getLinkUrl();
      });

      if (!hasLink) {
        cell.setValue('=GOOGLETRANSLATE("'+col+'","ja_JP","'+toLang+'")');
      }
    }
  }
}
