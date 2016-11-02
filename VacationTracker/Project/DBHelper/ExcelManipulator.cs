using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Office.Interop.Excel;
using System.Runtime.InteropServices;

namespace DBHelper
{
    public class ExcelManipulator
    {
        #region Declarations

        private ApplicationClass _XLApp;
        private Workbook _XLWorkBook;
        private Workbooks _XLWorkBooks;
        private Worksheet _XLWorkSheet;
        private bool _XLVisible;
        private bool _XLDisplayAlerts;
        private Range _CellRange;

        #endregion

        public ExcelManipulator()
        {
            _XLApp = new ApplicationClass();
        }

        ~ExcelManipulator()
        {
            //DisposeRange();
            //CloseSheet();
            //CloseDocument();
            //Dispose();
            //Marshal.ReleaseComObject(_CellRange);
            //Marshal.ReleaseComObject(_XLWorkSheet);
            //Marshal.ReleaseComObject(_XLWorkBooks);
            //Marshal.ReleaseComObject(_XLWorkBook);
            //Marshal.ReleaseComObject(_XLApp);
        }

        #region Public Properties

        public ApplicationClass XLApp
        {
            get { return _XLApp; }
        }

        public Workbook XLWorkBook
        {
            get { return _XLWorkBook; }
        }

        public Workbooks XLWorkBooks
        {
            get { return _XLWorkBooks; }
        }

        public Worksheet XLWorkSheet
        {
            get { return _XLWorkSheet; }
        }

        public Range CellRange
        {
            get { return _CellRange; }
            set { _CellRange = value; }
        }

        public bool XLVisible
        {
            get { return _XLVisible; }
            set { _XLVisible = value; }
        }

        public bool XLDisplayAlerts
        {
            get { return _XLDisplayAlerts; }
            set { _XLDisplayAlerts = value; }
        }

        #endregion

        #region OpenDocument

        public Workbook OpenDocument(string FilePath)
        {
            _XLApp.DisplayAlerts = _XLDisplayAlerts;
            _XLApp.Visible = _XLVisible;
            _XLWorkBooks = _XLApp.Workbooks;

            _XLWorkBook = _XLWorkBooks.Open(FilePath, Type.Missing, Type.Missing, Type.Missing, 
                Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, 
                Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);

            return _XLWorkBook;
        }

        #endregion

        #region ActivateSheet

        public Worksheet ActivateSheet(Workbook XLBook, int SheetNo)
        {
            if(SheetNo >=1 && SheetNo <= XLBook.Sheets.Count)
            {
                _XLWorkSheet = (Worksheet)XLBook.Sheets[SheetNo];
                _XLWorkSheet.Activate();
            }
            return _XLWorkSheet;
        }

        #endregion

        #region CloseSheet

        public void CloseSheet(Worksheet SheetToClose)
        {
            Marshal.ReleaseComObject(SheetToClose);
        }

        #endregion

        #region CloseSheet without parameter

        public void CloseSheet()
        {
            Marshal.ReleaseComObject(_XLWorkSheet);
        }

        #endregion

        #region CloseDocument

        public void CloseDocument(Workbook BookToClose)
        {
            if (BookToClose != null)
                BookToClose.Close(false, Type.Missing, Type.Missing);
            Marshal.ReleaseComObject(BookToClose);
        }

        #endregion

        #region CloseDocument without parameter

        public void CloseDocument()
        {
            if (_XLWorkBook != null)
                _XLWorkBook.Close(false, Type.Missing, Type.Missing);
            if (_XLWorkBooks != null)
                _XLWorkBooks.Close();
            Marshal.ReleaseComObject(_XLWorkBook);
            Marshal.ReleaseComObject(_XLWorkBooks);
        }

        #endregion

        #region Dispose

        public void Dispose(ApplicationClass XLApp)
        {
            if (XLApp != null)
            {
                XLApp.Workbooks.Close();
                XLApp.Quit();
            }
            Marshal.ReleaseComObject(XLApp);
        }

        #endregion

        #region Dispose without parameter

        public void Dispose()
        {
            if (_XLApp != null)
            {
                _XLApp.Workbooks.Close();
                _XLApp.Quit();
            }
            Marshal.ReleaseComObject(_XLApp);
        }

        #endregion

        #region DisposeRange without parameter

        public void DisposeRange()
        {
            Marshal.ReleaseComObject(_CellRange);
        }

        #endregion

        #region DisposeRange

        public void DisposeRange(Range RangeToDispose)
        {
            Marshal.ReleaseComObject(RangeToDispose);
        }

        #endregion

        #region SaveDocument

        public void SaveDocument(Workbook BookToSave, string FileName)
        {
            BookToSave.SaveAs(FileName, Type.Missing, Type.Missing, Type.Missing, Type.Missing, 
                Type.Missing, XlSaveAsAccessMode.xlShared, Type.Missing, Type.Missing, Type.Missing,
                Type.Missing, Type.Missing);
        }

        #endregion

        #region WriteText

        public void WriteText(int RowNo, int ColNo, string DataToWrite)
        {
            Range rng = (Range)_XLWorkSheet.Cells[RowNo, ColNo];
            rng.Value2 = DataToWrite;
        }

        #endregion

        #region ReadText

        public string ReadText(int RowNo, int ColNo)
        {
            Range rng = (Range)_XLWorkSheet.Cells[RowNo, ColNo];
            return Convert.ToString(rng.Value2);
        }

        #endregion

        #region InsertRows

        public void InsertRows(int InsertAt, int NumberOfRows)
        {
            for (int iCnt = 1; iCnt <= NumberOfRows; iCnt++)
            {
                Range rng = (Range)_XLWorkSheet.Cells[InsertAt, 1];
                Range row = rng.EntireRow;
                row.Insert(XlInsertShiftDirection.xlShiftDown, false);
                InsertAt++;
            }
        }

        #endregion

        #region CopyRows

        public void CopyRows(string SourceRange1, string SourceRange2,
            string DestinationRange1, string DestinationRange2)
        {
            Range rngSource = (Range)_XLWorkSheet.get_Range(SourceRange1, SourceRange2);
            Range rngDestination = (Range)_XLWorkSheet.get_Range(DestinationRange1, DestinationRange2);

            rngSource.EntireRow.Copy(rngDestination);
        }

        #endregion

        #region FindText

        public Range FindText(string StartRange, string EndRange, string FindWhat)
        {
            Range rngSource = (Range)_XLWorkSheet.get_Range(StartRange, EndRange);

            Range rngFound = rngSource.Find(FindWhat, Type.Missing, Type.Missing, XlLookAt.xlWhole,
                XlSearchOrder.xlByColumns, XlSearchDirection.xlNext, false, Type.Missing, Type.Missing);
            return rngFound;
        }

        #endregion

        #region FindTextPartial

        public Range FindTextPartial(string StartRange, string EndRange, string FindWhat)
        {
            Range rngSource = (Range)_XLWorkSheet.get_Range(StartRange, EndRange);

            Range rngFound = rngSource.Find(FindWhat, Type.Missing, Type.Missing, XlLookAt.xlPart,
                XlSearchOrder.xlByColumns, XlSearchDirection.xlNext, false, Type.Missing, Type.Missing);
            return rngFound;
        }

        #endregion

        #region FindRowNo

        public int FindRowNo(string StartRange, string EndRange, string FindWhat)
        {
            Range rngFound = FindText(StartRange, EndRange, FindWhat);
            int iRow = -1;
            if (rngFound != null)
            {
                iRow = rngFound.Row;
            }
            DisposeRange(rngFound);
            return iRow;
        }

        #endregion

        #region FindRowNoPartial

        public int FindRowNoPartial(string StartRange, string EndRange, string FindWhat)
        {
            Range rngFound = FindTextPartial(StartRange, EndRange, FindWhat);
            int iRow = -1;
            if (rngFound != null)
            {
                iRow = rngFound.Row;
            }
            DisposeRange(rngFound);
            return iRow;
        }

        #endregion
    }
}