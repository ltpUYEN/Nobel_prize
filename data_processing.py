import pandas as pd
import os
print(os.getcwd())

# 1. FUNCTION DEFINITION 
def combine_data(csv_path, excel_path, concat_path):  # These are just names!
    """Combines CSV and Excel data (assumes identical columns)."""
    try:
        df_csv = pd.read_csv(csv_path)       
        df_excel = pd.read_excel(excel_path)  
        df_final = pd.concat([df_csv, df_excel], ignore_index=True)
        df_final.to_csv(concat_path, index=False) 
        print(f"Combined data saved to {concat_path}")
        return df_final
    except (FileNotFoundError, pd.errors.ParserError, pd.errors.EmptyDataError, Exception) as e:
        print(f"Error: {e}")
        return None

# 2. FUNCTION CALL 
if __name__ == "__main__":
    
    my_csv_file = "/Frommypath/Project/Nobel2024/nobel_2023.csv"
    my_excel_file = "/Frommypath/Project/Nobel2024/Nobel_prizes_2024.xlsx"
    my_output_file = "/Frommypath/Project/Nobel2024/nobel_prizes.csv"

