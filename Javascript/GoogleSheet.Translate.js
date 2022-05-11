function translateSheet() {
  const sheets = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = sheets.getSheetByName('DetailDesign');
  const range = sheet.getRange('A2:AG5');
  const rangeRow = range.getRow();
  const rangeColumn = range.getColumn();
  const values = range.getValues();
  for (let rowI = 0; rowI < values.length; rowI++) {
    let row = values[rowI];
    for (let colI = 0; colI < row.length; colI++) {
      let col = row[colI];
      if (!col || !col.length) {
        continue;
      }

      // If english already
      if (col.match(/^[a-zA-Z0-9-_. ]+$/g)) {
        continue;
      }

      // TODO: Customize here
      if (col === '〇') {
        continue;
      }

      const rowINum = rowI + rangeRow;
      const colINum = colI + rangeColumn;

      // Default will translate to English
      let toLang = 'en_US';

      // From line you want to translate to vi
      if (rowI >= 801) {
        // If has dot character -> not translate
        if (col.indexOf('.') === -1) {
          toLang = 'vi';
        }
      }

      const cell = sheet.getRange(rowINum, colINum);

      Logger.log(cell.getValue());

      continue;
      let hasLink = false;
      cell.getRichTextValue().getRuns().forEach(v => {
        if (hasLink) {
          return;
        }
        hasLink = v.getLinkUrl();
      });

      if (!hasLink) {
        cell.setValue('=GOOGLETRANSLATE("'+col+'","ja_JP","'+toLang+'")');
      }
    }
  }
}
