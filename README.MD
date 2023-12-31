Project to extract financial data from SEC Filings.

Download and extraction is performed with a combination of shell scripts 
and python code in Jupyter notebooks.

Shell scripts are under KSH.

Jupyter notebooks are under notebook/SEC. 

1. Download files : 'Download SEC Filings'.ipynb

Get list of Russell 1000 companies from wikipeadia. Downlod files from SEC
website.

2. Validate files : extract_docs.ksh

Validate files and move them to staging area. Extract FilingSummary.xml file.

3. Extract reports : extract_reports.ksh

Extract reports using FilingSummary.xml as lookup.

4. Extract tables from reports : Stage2_Extract_Tables.ipynb

Extract table from the report and tidy up the formating.

5. Balance sheet, refine line items : Stage2_Extract_Balance.ipynb
                                      Stage2_Balance_Check_Labels.ipynb

Reformat line items using pattern matches.

6. Cash sheet, refine line items : stage2_Extract_Cash.ipynb
                                   stage2_Cash_Check_Labels.ipynb

Same as 5.

7. Income sheet, refine line items : stage2_Extract_Income.ipynb
                                     stage2_Income_Check_Labels.ipynb

Same as 5.

8. Balance Sheet, Map line items : stage3_Map_Line_items_Balance.ipynb

Assign tags to line items of interest using pattern matching

9. Cash Sheet, Map line items : stage3_Map_Line_items_Cash.ipynb

Same as 8.

10. Income sheet, Map line items : stage3_Map_Line _items_Income.ipynb

Same as 8.

11. Balance sheet, refine data : stage4_Balance_Refine_Data.ipynb

Extract line items of interest

12. Cash sheet, refine data : stage4_Cash_Refine_Data.ipynb

Same as 11.

13. Income sheet, refine data : stage4_Cash_Refine_Data.ipynb

Same as 12.

14. Create standardised table : Stage4_Create_Std_Table

    


