# PANDAS INTERVIEW GUIDE
## Complete Reference for Data Engineer Interviews

---

## Cheat Sheet

### 1. Imports
```python
import pandas as pd
from pandas import DataFrame
```

### 2. Create a dataframe
```python
df = pd.DataFrame(lists, columns = ['id', 'name', 'age'])
df = pd.DataFrame(dict)
df = pd.DataFrame(dict,columns=column_names,index=row_label)
df = pd.read_csv("text.txt",
					sep=" ", 							# multiple seperator sep='[:, |_]'
					header=None,						# or Integer (e.g., 0, 1, 2, ...), zero-indexed row number to be used as the header
					nrows=3,							# Number of rows to be read
					skiprows=9,							# skip first 9 lines or skiprows=[5, 6] skip 4th and 5th index
					columns = ['id', 'name', 'age'],
					usecols=["First Name", "Email"],	# read only this column
					na_values=["N/A", "Unknown"],
					parse_dates=["Date of birth"]
				)
df.to_csv('new_file.csv', sep=',', index=False)
```

### 3. Alter a dataframe
```python
df.columns = column_list
df.index = index_list or df = df.set_index('column') or df.set_index(['column1', 'column2']) #custom indexed dataframe with one of its columns
df_reset = df.reset_index(), df.reset_index(drop=True)	#drop old index
```

### 4. Get dataframe details
```python
df.info(), print(df.describe())
df.to_string(index=False), df_string.split('\n')
df.head(-2), df.tail(3), df.T or df.transpose()
Column names/datatypes		:	list(df.columns) or df.columns.values or df.axes[1].values 			# .columns and .index are a index type
							:	df.dtypes, df.dtypes.index, df.dtypes.values, df.dtypes.items() 	# .dtype is series type
Row/Index					: 	df.index.values or df.axes[0].values								# .axes is a list type
(rows, cols), rows*columns	:	df.shape, df.shape[0], df.shape[1], df.size							# .shape is a touple type, .size is a int type
```

### 5. Transform data
```python
Type conversion			:	df['Price'] = df['Price'].str.replace(',', '').astype(float) 		#.astype(float)
						: 	df['publish_date'] = df['publish_date'].astype('datetime64[ns]')
Add row 	    		: 	df.loc['k'] = [1, 'Suresh', 'yes', 15.5] # .loc[] .append()
Add row at the end		: 	df.loc[len(df.index)] = ['Amy', 89, 93]
						: 	df.loc[df.shape[0]] = ['Amy', 89, 93]
						:	df.append(dicts, ignore_index=True, sort=False)
						:	df.loc[:, df.columns != 'col3'] 	# filters everything but col3
						:	df.columns.get_loc("col2")
Update a column			: 	df.set_value(8, 'score', 10.2)
						:	df['name'] = df['name'].replace('James', 'Suresh')
						:	df['qualify'] = df['qualify'].map({'yes': True, 'no': False})
Delete row     			: 	df = df.drop('k', axis=0)
Delete Column 			: 	df = df.drop('Ticker', axis=1)
						:	s = df.pop('attempts') - s - just gives you that column data as a series, df would have dropped that column
Add new columns			:	df = df.assign(TutorsAssigned=tutors)
							df['TutorsAssigned'] = tutors 			#same effect as above
						:	df = df.assign(Discount_Percent=lambda x: x.Fee * x.Discount / 100)
						:	df.insert(3,'TutorsAssigned', tutors ) - 3 is column number to be inserted at
```

### 6. Parsing & Processing
```python
df.iloc[:3] or df.iloc[[1, 3, 5, 6]] or df.iloc[0,0]  or df.iloc[[1, 3, 5, 6], [1, 3]] or df.iloc[[0,1], :]
df.loc['d', 'score'] = 11.59, df[['column_name1', 'column_name2']] eg: df[['name', 'score']]
df = df.sort_values(by =['id', 'age'], ascending=[True,False]) # dataframe after sorting by 'id' and 'age'
df = df.rename(columns = {'User_ID':'Bought', 'IP_Address':'Clicked'})
df[df['score'].between(15, 20)] or df[(df['score'] > 15) & (df['score'] <20)] or df[(df['attempts'] < 2) | (df['score'] > 15)] or condition can is '|'
df[df.age>25] or df.loc[df.age>25]
df = df.filter(items = ['IP_Address','Ad_Text'])
df = df.query("`favorite_color`in('red','green')and`grade`>90")
regions_of_interest = ['North', 'East']
north_east_sales = sales_df.query('region in @regions_of_interest') # @ is an external variable. Can be anything

df = df.groupby(["city"]).size().reset_index(name='Number of people')
df = df.groupby('Ad_Text')['User_ID'].count().reset_index(name='count')
df = df.groupby('occ')['salary'].mean() # required dataframe
df = df.groupby('col1')['col2'].apply(list)
df = df.groupby('school_code').agg({'age': ['mean', 'min', 'max']})
df = df.groupby(['customer_id','salesman_id']).agg({'purch_amt':sum})
df = sales_df\
	.groupby(['region', 'product'])\
	.agg(
		product_sales = ('total_sales','sum'),
		sales_count = ('quantity', 'sum')
	)
df = sales_df\
	.groupby('salesperson')\
	.agg({

			'total_sales': ['sum', 'mean', 'std'],
			'quantity': ['sum', 'max'],
			'price': ['min', 'max', 'median']
		})
df = sales_df\
	.groupby('region')\
	.agg(
		total = ('total_sales', 'sum'),
		average = ('total_sales', 'mean'),
		range = ('total_sales', lambda x: x.max() - x.min()),
		top_10_percent = ('total_sales', lambda x: x.quantile(0.9))
	)

df.groupby('salesperson')\
	.rolling(window=7, min_periods=1)\
	.agg({'total_sales': 'mean'})\
	.reset_index(0, drop=True)

df.groupby('region')['total_sales']\
								.rank(method='dense', ascending=False)

df['col'].argmax() 	# index position of the max value
df.groupby('col1')['col2'].nlargest(5)
```

### 7. Merge
```python
df = pd.merge(df1, df2, left_on='Courses', right_on='Courses') or df = pd.merge(df1, df2, on='Courses')
df = pd.merge(df3, df1,  how='left', left_on=['Col1','col2'], right_on = ['col1','col2'])
df = pd.merge(emp_data, company_data, how = 'inner', on = 'eid') # required dataframe
df = pd.merge(df1, df2, how='inner', left_index=True, right_index=True)
df = df1.join(df2, lsuffix="_left", rsuffix="_right", how='inner') - joining on indexes
df.concat([df1, df2],axis=0) -> works as union df.concat([df1, df2],axis=1) -> horiozontal join, df.concat([df1, df2],axis=0, ignore_index=True)

emp_with_managers = pd.merge(
							employees_df, employees_df,
							left_on='manager_id',
							right_on='emp_id',
							how='left',
							suffixes=('', '_manager')
						)
```

### 8. Handy iterations
```python
df.isnull().sum() or df.isnull().values.sum()
company_data['profit'] = company_data['profit'].apply(lambda x:x>0) #Convert the values of Profit column such that values in it greater than 0 are set to True
df = pd.DataFrame([sub.split(",") for sub in all_user_ips], columns =['User_ID', 'IP_Address'])
df.values.tolist()
```

### 9. Looping
```python
for index, row in df.iterrows():
	print (index,row["Fee"], row["Courses"])
for row in df.itertuples(index = True):
	print (getattr(row,'Index'),getattr(row, "Fee"), getattr(row, "Courses"))
```

---

# 1. Setup and DataFrame Creation

## 1.1 Essential Imports

```python
import pandas as pd
import numpy as np
from pandas import DataFrame, Series
```

## 1.2 Creating DataFrames

### From Lists

```python
# From list of lists
data = [
    [1, 'Alice', 25],
    [2, 'Bob', 30],
    [3, 'Charlie', 35]
]
df = pd.DataFrame(data, columns=['id', 'name', 'age'])

# From list of dictionaries
data = [
    {'id': 1, 'name': 'Alice', 'age': 25},
    {'id': 2, 'name': 'Bob', 'age': 30},
    {'id': 3, 'name': 'Charlie', 'age': 35}
]
df = pd.DataFrame(data)
```

### From Dictionary

```python
# Dictionary with lists as values
data = {
    'id': [1, 2, 3],
    'name': ['Alice', 'Bob', 'Charlie'],
    'age': [25, 30, 35]
}
df = pd.DataFrame(data)

# With custom index
df = pd.DataFrame(
    data,
    columns=['id', 'name', 'age'],
    index=['row1', 'row2', 'row3']
)

# From dictionary of Series (different lengths handled with NaN)
data = {
    'A': pd.Series([1, 2, 3]),
    'B': pd.Series([4, 5, 6, 7])  # Extra value
}
df = pd.DataFrame(data)
```

**💡 Interview Tip:** When creating from dict of lists, all lists must have same length. Use dict of Series for different lengths.

## 1.3 Reading CSV Files

### Basic CSV Reading

```python
# Simple read
df = pd.read_csv('data.csv')

# With custom separator
df = pd.read_csv('data.txt', sep='	')

# Multiple separators (regex)
df = pd.read_csv('data.txt', sep='[:, |_]', engine='python')

# Specific columns only
df = pd.read_csv('data.csv', usecols=['name', 'age', 'salary'])
```

### Advanced CSV Reading

```python
# Complete example with all options
df = pd.read_csv(
    'data.csv',
    sep=',',                              # Separator
    header=0,                             # Row number for column names (0-indexed)
    names=['id', 'name', 'age'],          # Custom column names
    index_col='id',                       # Set column as index
    usecols=['id', 'name', 'age'],        # Only read these columns
    dtype={'age': int, 'salary': float},  # Specify data types
    nrows=100,                            # Read only first 100 rows
    skiprows=5,                           # Skip first 5 rows
    skiprows=[1, 3, 5],                   # Skip specific rows
    na_values=['NA', 'N/A', 'Unknown'],   # Additional NA values
    parse_dates=['date_column'],          # Parse as datetime
    encoding='utf-8'                      # File encoding
)

# Read without header
df = pd.read_csv('data.txt', header=None)

# Skip rows with condition
df = pd.read_csv('data.csv', skiprows=lambda x: x in [2, 4, 6])
```

**💡 Common Interview Question:** How to read large files efficiently?

```python
# Read in chunks
chunk_size = 10000
chunks = []
for chunk in pd.read_csv('large_file.csv', chunksize=chunk_size):
    # Process each chunk
    processed = chunk[chunk['age'] > 25]
    chunks.append(processed)

df = pd.concat(chunks, ignore_index=True)

# Or use iterator
reader = pd.read_csv('large_file.csv', iterator=True)
df = reader.get_chunk(1000)  # Get first 1000 rows
```

## 1.4 Writing to Files

```python
# Write to CSV
df.to_csv('output.csv', index=False)

# With custom separator and encoding
df.to_csv('output.txt', sep='	', index=False, encoding='utf-8')

# Write only specific columns
df[['name', 'age']].to_csv('subset.csv', index=False)

# Append to existing file
df.to_csv('output.csv', mode='a', header=False, index=False)

# Write to Excel
df.to_excel('output.xlsx', sheet_name='Sheet1', index=False)

# Multiple sheets
with pd.ExcelWriter('output.xlsx') as writer:
    df1.to_excel(writer, sheet_name='Sales', index=False)
    df2.to_excel(writer, sheet_name='Products', index=False)
```

---

# 2. DataFrame Information and Inspection

## 2.1 Basic Information

```python
# Display methods
df.head()           # First 5 rows
df.head(10)         # First 10 rows
df.head(-2)         # All except last 2 rows
df.tail()           # Last 5 rows
df.tail(3)          # Last 3 rows

# Complete data view
print(df)                        # Truncated view
print(df.to_string())            # Complete view
print(df.to_string(index=False)) # Without index

# Transpose
df.T                # Swap rows and columns
df.transpose()      # Same as .T
```

## 2.2 DataFrame Properties

```python
# Shape and size
df.shape            # (rows, columns) - tuple
df.shape[0]         # Number of rows
df.shape[1]         # Number of columns
df.size             # Total elements (rows * columns)
len(df)             # Number of rows
len(df.columns)     # Number of columns

# Columns
df.columns                      # Index object
list(df.columns)                # List of column names
df.columns.values               # NumPy array
df.columns.tolist()             # List
df.axes[1]                      # Columns axis

# Index
df.index                        # Index object
df.index.values                 # Values
df.index.tolist()               # As list
df.axes[0]                      # Index axis

# Data types
df.dtypes                       # Series of dtypes
df.dtypes.index                 # Column names
df.dtypes.values                # Array of dtypes
list(df.dtypes.items())         # List of (col, dtype) tuples

# Get column position
df.columns.get_loc('age')       # Returns integer position
```

**💡 Interview Tip:** `.axes` returns a list of [row_index, column_index]

## 2.3 Statistical Summary

```python
# Summary statistics
df.info()           # Overview: columns, dtypes, non-null counts, memory
df.describe()       # Statistical summary for numeric columns
df.describe(include='all')      # Include non-numeric columns

# Individual statistics
df.mean()           # Column means
df.median()         # Column medians
df.mode()           # Column modes
df.std()            # Standard deviation
df.var()            # Variance
df.min()            # Minimum values
df.max()            # Maximum values
df.sum()            # Column sums
df.count()          # Non-null counts
df.nunique()        # Number of unique values per column

# Correlation and covariance
df.corr()           # Correlation matrix
df.cov()            # Covariance matrix
df['A'].corr(df['B'])  # Correlation between two columns
```

**Example Output:**

```python
>>> df.describe()
              age      salary
count    5.000000    5.000000
mean    32.000000   67500.000000
std      7.905694   13540.064032
min     23.000000   50000.000000
25%     27.000000   60000.000000
50%     30.000000   65000.000000
75%     35.000000   75000.000000
max     45.000000   85000.000000
```

## 2.4 Memory Usage

```python
# Memory usage by column
df.memory_usage()                    # Bytes per column
df.memory_usage(deep=True)           # Include object sizes
df.memory_usage(index=False)         # Exclude index

# Total memory
df.memory_usage(deep=True).sum()     # Total in bytes
df.info(memory_usage='deep')         # Detailed memory info
```

---

# 3. Data Selection and Indexing

## 3.1 Column Selection

```python
# Single column (returns Series)
df['name']
df.name                     # Only works for valid Python identifiers

# Multiple columns (returns DataFrame)
df[['name', 'age']]
df[['name', 'age', 'salary']]

# All columns except one
df.loc[:, df.columns != 'age']
df.drop('age', axis=1)      # Returns new DataFrame
df.drop(['age', 'salary'], axis=1)  # Drop multiple

# Select columns by data type
df.select_dtypes(include=['int64', 'float64'])  # Numeric only
df.select_dtypes(include=['object'])            # String columns
df.select_dtypes(exclude=['object'])            # All except strings
```

## 3.2 Row Selection with loc and iloc

### iloc - Integer-based indexing

```python
# Single row
df.iloc[0]                  # First row (Series)
df.iloc[-1]                 # Last row

# Multiple rows
df.iloc[:3]                 # First 3 rows
df.iloc[2:5]                # Rows 2, 3, 4
df.iloc[[1, 3, 5]]          # Specific rows

# Single value
df.iloc[0, 0]               # First row, first column
df.iloc[2, 3]               # Row 2, column 3

# Slicing rows and columns
df.iloc[:3, :2]             # First 3 rows, first 2 columns
df.iloc[[0, 2], [1, 3]]     # Specific rows and columns
df.iloc[:, [0, 2, 4]]       # All rows, specific columns
```

### loc - Label-based indexing

```python
# Single row by label
df.loc['row1']

# Multiple rows
df.loc[['row1', 'row3']]
df.loc['row1':'row3']       # Inclusive slicing

# Specific cell
df.loc['row1', 'age']

# Multiple cells
df.loc[['row1', 'row2'], ['name', 'age']]

# All rows, specific columns
df.loc[:, ['name', 'age']]

# Boolean indexing with loc
df.loc[df['age'] > 25]
df.loc[df['age'] > 25, ['name', 'salary']]
```

**💡 Interview Tip:** 
- `iloc` uses integer positions (0-based, exclusive end)
- `loc` uses labels (inclusive on both ends)
- `loc` can use boolean arrays

## 3.3 Setting Values

```python
# Set single value
df.loc['row1', 'age'] = 30
df.iloc[0, 2] = 30

# Set multiple values
df.loc['row1', ['age', 'salary']] = [30, 75000]

# Set entire column
df['bonus'] = 5000
df['bonus'] = df['salary'] * 0.1

# Set with condition
df.loc[df['age'] > 30, 'senior'] = True
df.loc[df['age'] <= 30, 'senior'] = False

# Deprecated: .set_value() - use .loc instead
# Old: df.set_value('row1', 'age', 30)
# New: df.loc['row1', 'age'] = 30
```

## 3.4 Index Management

```python
# Set index
df.set_index('id')                      # Use column as index
df.set_index('id', inplace=True)        # Modify in place
df.set_index(['dept', 'emp_id'])        # Multi-index

# Reset index
df.reset_index()                        # Move index to column
df.reset_index(drop=True)               # Discard old index
df.reset_index(inplace=True)            # Modify in place

# Change index
df.index = ['a', 'b', 'c']              # New index labels
df.index = range(len(df))               # Numbered index

# Change column names
df.columns = ['col1', 'col2', 'col3']
df.rename(columns={'old_name': 'new_name'})
df.rename(columns={'User_ID': 'UserID', 'IP_Address': 'IP'})
df.rename(columns=str.lower)            # Apply function to all
df.rename(columns=lambda x: x.strip())  # Remove whitespace
```

---

# 4. Data Transformation

## 4.1 Type Conversion

```python
# Convert column types
df['age'] = df['age'].astype(int)
df['price'] = df['price'].astype(float)
df['date'] = df['date'].astype('datetime64[ns]')

# Convert multiple columns
df = df.astype({'age': int, 'salary': float, 'active': bool})

# Handle errors
df['price'] = pd.to_numeric(df['price'], errors='coerce')  # Invalid -> NaN
df['date'] = pd.to_datetime(df['date'], errors='coerce')

# String to numeric (remove characters first)
df['price'] = df['price'].str.replace(',', '').astype(float)
df['price'] = df['price'].str.replace('$', '').astype(float)
df['pct'] = df['pct'].str.rstrip('%').astype(float) / 100
```

**💡 Common Interview Question:** Clean currency data

```python
# Remove currency symbols and convert to float
df['price'] = (df['price']
               .str.replace('$', '')
               .str.replace(',', '')
               .astype(float))

# Or using regex
df['price'] = (df['price']
               .str.replace(r'[$,]', '', regex=True)
               .astype(float))
```

## 4.2 Adding Rows

```python
# Add single row using loc
df.loc[len(df)] = [4, 'David', 28]
df.loc[df.shape[0]] = [5, 'Eva', 32]

# Add row with label
df.loc['new_row'] = [6, 'Frank', 40]

# Append dictionary (deprecated, use concat)
new_row = {'id': 7, 'name': 'Grace', 'age': 27}
df = pd.concat([df, pd.DataFrame([new_row])], ignore_index=True)

# Append DataFrame
new_rows = pd.DataFrame([
    {'id': 8, 'name': 'Henry', 'age': 35},
    {'id': 9, 'name': 'Iris', 'age': 29}
])
df = pd.concat([df, new_rows], ignore_index=True)
```

**💡 Interview Tip:** Avoid `df.append()` (deprecated). Use `pd.concat()` instead.

## 4.3 Adding Columns

```python
# Simple assignment
df['bonus'] = 5000

# From list
tutors = ['John', 'Jane', 'Jack']
df['tutor'] = tutors

# Calculated column
df['total_compensation'] = df['salary'] + df['bonus']
df['tax'] = df['salary'] * 0.3

# Using assign (returns new DataFrame)
df = df.assign(bonus=5000)
df = df.assign(total=lambda x: x['salary'] + x['bonus'])
df = df.assign(
    bonus=5000,
    tax=lambda x: x['salary'] * 0.3,
    net=lambda x: x['salary'] - x['tax']
)

# Insert at specific position
df.insert(2, 'middle_name', ['M'] * len(df))  # Insert at index 2
df.insert(0, 'row_num', range(len(df)))       # Insert at beginning
```

## 4.4 Removing Rows and Columns

```python
# Drop rows
df.drop('row1')                     # By label
df.drop('row1', axis=0)             # Explicit axis
df.drop(['row1', 'row2'])           # Multiple rows
df.drop(df.index[[0, 2, 4]])        # By position

# Drop columns
df.drop('age', axis=1)              # Single column
df.drop(['age', 'salary'], axis=1)  # Multiple columns

# Pop column (returns Series, modifies DataFrame)
salary_col = df.pop('salary')

# Drop with condition
df = df[df['age'] >= 18]            # Keep only adults
df = df[df['salary'].notna()]       # Keep non-null salaries

# Drop duplicates
df.drop_duplicates()                # All columns
df.drop_duplicates(subset=['email'])  # Based on specific column
df.drop_duplicates(subset=['first_name', 'last_name'], keep='first')
df.drop_duplicates(keep='last')     # Keep last occurrence
df.drop_duplicates(keep=False)      # Remove all duplicates
```

## 4.5 String Operations

```python
# String methods (use .str accessor)
df['name_upper'] = df['name'].str.upper()
df['name_lower'] = df['name'].str.lower()
df['name_title'] = df['name'].str.title()

# Replace
df['text'] = df['text'].str.replace('old', 'new')
df['text'] = df['text'].str.replace(r'\d+', '', regex=True)  # Remove digits

# Strip whitespace
df['name'] = df['name'].str.strip()
df['name'] = df['name'].str.lstrip()
df['name'] = df['name'].str.rstrip()

# Split
df[['first_name', 'last_name']] = df['name'].str.split(' ', expand=True)
df['domain'] = df['email'].str.split('@').str[1]

# Contains
df[df['email'].str.contains('@gmail.com')]
df[df['name'].str.contains('John', case=False)]

# Extract with regex
df['area_code'] = df['phone'].str.extract(r'(\d{3})')
df[['first', 'last']] = df['name'].str.extract(r'(\w+)\s+(\w+)')

# Length
df['name_length'] = df['name'].str.len()

# Pad
df['id_padded'] = df['id'].astype(str).str.zfill(5)  # Zero pad
df['text_padded'] = df['text'].str.pad(10, fillchar='*')
```

**💡 Common Interview Pattern:** Parse email domains

```python
# Extract domain from email
df['domain'] = df['email'].str.split('@').str[1]

# Or using extract
df['domain'] = df['email'].str.extract(r'@(.+)$')

# Count emails by domain
domain_counts = df['domain'].value_counts()
```

## 4.6 Mapping and Replacing

```python
# Map with dictionary
status_map = {'Y': 'Yes', 'N': 'No', 'M': 'Maybe'}
df['status_full'] = df['status'].map(status_map)

# Map with function
df['age_group'] = df['age'].map(lambda x: 'Adult' if x >= 18 else 'Minor')

# Replace values
df['qualify'] = df['qualify'].replace({'yes': True, 'no': False})
df['status'] = df['status'].replace([1, 2, 3], ['Low', 'Med', 'High'])

# Replace with regex
df['text'] = df['text'].str.replace(r'\d+', 'NUMBER', regex=True)

# Replace NaN
df['age'] = df['age'].fillna(0)
df['name'] = df['name'].fillna('Unknown')
df.fillna({'age': 0, 'salary': df['salary'].mean()})

# Apply function
df['salary_category'] = df['salary'].apply(
    lambda x: 'High' if x > 70000 else 'Low'
)

# Apply to multiple columns
df['full_name'] = df.apply(
    lambda row: f"{row['first_name']} {row['last_name']}", 
    axis=1
)
```

---

# 5. Data Cleaning

## 5.1 Handling Missing Data

```python
# Check for missing values
df.isnull()                         # Boolean DataFrame
df.isnull().sum()                   # Count per column
df.isnull().sum().sum()             # Total missing values
df.isnull().values.sum()            # Alternative
df.isna()                           # Alias for isnull()

# Check if any/all values are null
df.isnull().any()                   # Any null per column
df.isnull().all()                   # All null per column
df['age'].isnull().any()            # Any null in specific column

# Find rows with missing values
df[df.isnull().any(axis=1)]         # Rows with any null
df[df['age'].isnull()]              # Rows where age is null

# Drop missing values
df.dropna()                         # Drop rows with any null
df.dropna(axis=1)                   # Drop columns with any null
df.dropna(subset=['age', 'salary']) # Drop if specific columns null
df.dropna(thresh=2)                 # Keep rows with at least 2 non-null
df.dropna(how='all')                # Drop only if all values are null

# Fill missing values
df.fillna(0)                        # Fill all with 0
df.fillna({'age': 0, 'salary': 50000})  # Different values per column
df['age'].fillna(df['age'].mean())  # Fill with mean
df['age'].fillna(df['age'].median())  # Fill with median
df['category'].fillna(df['category'].mode()[0])  # Fill with mode

# Forward/backward fill
df.fillna(method='ffill')           # Forward fill
df.fillna(method='bfill')           # Backward fill

# Interpolate
df['values'].interpolate()          # Linear interpolation
df['values'].interpolate(method='polynomial', order=2)
```

**💡 Interview Tip:** Always check for missing data before analysis. Different strategies for different data types.

## 5.2 Handling Duplicates

```python
# Find duplicates
df.duplicated()                     # Boolean Series
df.duplicated().sum()               # Count duplicates
df[df.duplicated()]                 # Show duplicate rows

# Based on specific columns
df.duplicated(subset=['email'])
df[df.duplicated(subset=['first_name', 'last_name'])]

# Keep first or last occurrence
df.duplicated(keep='first')         # Mark all but first as duplicate
df.duplicated(keep='last')          # Mark all but last as duplicate
df.duplicated(keep=False)           # Mark all duplicates

# Remove duplicates
df.drop_duplicates()
df.drop_duplicates(subset=['email'])
df.drop_duplicates(subset=['first_name', 'last_name'], keep='last')
df.drop_duplicates(keep=False)      # Remove all duplicates
```

**💡 Common Interview Question:** Find all duplicate emails

```python
# Method 1: Using duplicated
duplicate_emails = df[df.duplicated(subset=['email'], keep=False)]

# Method 2: Using groupby
duplicate_emails = df.groupby('email').filter(lambda x: len(x) > 1)

# Method 3: Using value_counts
email_counts = df['email'].value_counts()
duplicates = email_counts[email_counts > 1].index
duplicate_emails = df[df['email'].isin(duplicates)]
```

## 5.3 Data Validation

```python
# Check unique values
df['category'].unique()             # Array of unique values
df['category'].nunique()            # Count of unique values
df['category'].value_counts()       # Frequency of each value

# Check data types
df.dtypes
df['age'].dtype

# Check value ranges
df['age'].min(), df['age'].max()
df['age'].between(0, 120).all()     # Validate age range

# Validate email format
df['email'].str.contains('@').all()
df['email'].str.match(r'^[\w\.-]+@[\w\.-]+\.\w+$').all()

# Find outliers (using IQR method)
Q1 = df['salary'].quantile(0.25)
Q3 = df['salary'].quantile(0.75)
IQR = Q3 - Q1
lower_bound = Q1 - 1.5 * IQR
upper_bound = Q3 + 1.5 * IQR
outliers = df[(df['salary'] < lower_bound) | (df['salary'] > upper_bound)]
```

---

# 6. Filtering and Querying

## 6.1 Boolean Indexing

```python
# Simple conditions
df[df['age'] > 25]
df[df['salary'] >= 50000]
df[df['name'] == 'Alice']

# Multiple conditions (use & and |, not 'and'/'or')
df[(df['age'] > 25) & (df['salary'] > 60000)]
df[(df['age'] < 25) | (df['age'] > 60)]
df[(df['dept'] == 'IT') & (df['salary'] > 70000)]

# NOT condition
df[~(df['age'] > 25)]               # Age <= 25
df[~df['status'].isin(['active', 'pending'])]

# Between
df[df['age'].between(25, 35)]
df[df['age'].between(25, 35, inclusive='neither')]  # Exclusive

# String conditions
df[df['name'].str.startswith('A')]
df[df['name'].str.endswith('son')]
df[df['name'].str.contains('John')]
df[df['email'].str.contains('@gmail.com')]

# NULL checks
df[df['age'].isnull()]
df[df['age'].notnull()]

# Membership
df[df['dept'].isin(['IT', 'Sales', 'HR'])]
df[df['id'].isin(important_ids)]
```

**💡 Interview Tip:** Always use `&` and `|` (not `and`/`or`) with parentheses for each condition.

## 6.2 Query Method

```python
# Using query (cleaner syntax for complex conditions)
df.query('age > 25')
df.query('age > 25 and salary > 60000')
df.query('age > 25 or age < 60')
df.query('dept in ["IT", "Sales"]')
df.query('age > 25 and dept == "IT"')

# Using variables (with @)
min_age = 25
df.query('age > @min_age')

regions_of_interest = ['North', 'East']
df.query('region in @regions_of_interest')

# Column names with spaces (use backticks)
df.query('`favorite color` == "red"')
df.query('`favorite color` in ["red", "green"] and grade > 90')

# Complex conditions
df.query('(age > 25 and dept == "IT") or (age > 40 and dept == "Sales")')
```

**💡 Interview Tip:** `.query()` is cleaner for complex conditions but can't use custom functions.

```python
# Chained queries (readable alternative to one long condition)
df.query('total_sales > 500').query("region in ['North', 'South']").query('is_online == True')

# query() can't span multiple lines - use eval() + boolean indexing instead
mask = df.eval("""
    total_sales > 1000 and \
    discount < 0.1 and \
    customer_type == 'Premium'
""")
df[mask]
```

## 6.3 Filtering by String Patterns

```python
# Contains
df[df['name'].str.contains('John')]
df[df['name'].str.contains('John', case=False)]  # Case-insensitive
df[df['name'].str.contains('John|Jane')]         # Multiple patterns

# Regex patterns
df[df['email'].str.contains(r'@gmail\.com$')]
df[df['phone'].str.match(r'^\d{3}-\d{3}-\d{4}$')]

# Starts with / ends with
df[df['name'].str.startswith('A')]
df[df['email'].str.endswith('.com')]

# String length
df[df['name'].str.len() > 10]
```

## 6.4 Filter Method

```python
# Filter rows by index
df.filter(items=['row1', 'row3'], axis=0)

# Filter columns by name
df.filter(items=['name', 'age'], axis=1)
df.filter(items=['name', 'age'])  # axis=1 is default

# Filter with regex
df.filter(regex='^name')           # Columns starting with 'name'
df.filter(regex='date$')           # Columns ending with 'date'
df.filter(regex='id|name')         # Columns containing 'id' or 'name'

# Filter with function
df.filter(like='_date')            # Columns containing '_date'
```

---

# 7. Aggregation and Grouping

## 7.1 Basic Grouping

```python
# Group and count
df.groupby('dept').size()                    # Count per group
df.groupby('dept')['salary'].count()         # Non-null count
df.groupby('dept').size().reset_index(name='count')

# Group and aggregate
df.groupby('dept')['salary'].sum()
df.groupby('dept')['salary'].mean()
df.groupby('dept')['salary'].median()
df.groupby('dept')['salary'].min()
df.groupby('dept')['salary'].max()
df.groupby('dept')['salary'].std()
df.groupby('dept')['salary'].var()

# Multiple columns
df.groupby(['dept', 'location'])['salary'].mean()
df.groupby(['dept', 'location']).size()
```

**Example:**

```python
>>> df.groupby('dept')['salary'].mean()
dept
IT         75000.0
Sales      65000.0
HR         55000.0
Name: salary, dtype: float64
```

## 7.2 Multiple Aggregations

```python
# Aggregate multiple columns
df.groupby('dept')[['salary', 'age']].mean()

# Multiple aggregations on one column
df.groupby('dept')['salary'].agg(['mean', 'min', 'max'])
df.groupby('dept')['salary'].agg(['mean', 'median', 'std', 'count'])

# Different aggregations for different columns
df.groupby('dept').agg({
    'salary': ['mean', 'min', 'max'],
    'age': ['mean', 'median'],
    'id': 'count'
})

# Named aggregations (Pandas 0.25+)
df.groupby('dept').agg(
    avg_salary=('salary', 'mean'),
    min_salary=('salary', 'min'),
    max_salary=('salary', 'max'),
    employee_count=('id', 'count')
)
```

**💡 Common Interview Pattern:** Sales summary by region and product

```python
sales_summary = (
    df.groupby(['region', 'product'])
    .agg(
        total_sales=('amount', 'sum'),
        avg_sale=('amount', 'mean'),
        transaction_count=('id', 'count'),
        max_sale=('amount', 'max')
    )
    .reset_index()
)
```

## 7.3 Custom Aggregations

```python
# Using lambda functions
df.groupby('dept').agg({
    'salary': [
        'mean',
        ('range', lambda x: x.max() - x.min()),
        ('top_10_pct', lambda x: x.quantile(0.9))
    ]
})

# Multiple custom aggregations
df.groupby('region').agg(
    total=('sales', 'sum'),
    average=('sales', 'mean'),
    range=('sales', lambda x: x.max() - x.min()),
    coefficient_of_variation=('sales', lambda x: x.std() / x.mean())
)

# Apply custom function to all columns
def calculate_stats(x):
    return pd.Series({
        'count': len(x),
        'mean': x.mean(),
        'std': x.std(),
        'cv': x.std() / x.mean() if x.mean() != 0 else 0
    })

df.groupby('dept')['salary'].apply(calculate_stats)
```

## 7.4 Transform and Filter

```python
# Transform: Return same-sized result
df['salary_normalized'] = df.groupby('dept')['salary'].transform(
    lambda x: (x - x.mean()) / x.std()
)

# Percent of group total
df['pct_of_dept_total'] = df.groupby('dept')['salary'].transform(
    lambda x: x / x.sum()
)

# Filter groups
# Keep only departments with average salary > 60000
df_filtered = df.groupby('dept').filter(lambda x: x['salary'].mean() > 60000)

# Keep groups with more than 5 members
df_filtered = df.groupby('dept').filter(lambda x: len(x) > 5)
```

**💡 Interview Tip:** 
- `agg()`: Returns aggregated result (smaller DataFrame)
- `transform()`: Returns same-sized result (can assign back to original DataFrame)
- `filter()`: Returns subset of original DataFrame based on group conditions

## 7.5 Group and Apply

```python
# Convert to list per group
df.groupby('dept')['name'].apply(list)

# Get top N per group
df.groupby('dept').apply(lambda x: x.nlargest(3, 'salary'))

# Custom operation per group
def get_salary_range(group):
    return pd.Series({
        'min_salary': group['salary'].min(),
        'max_salary': group['salary'].max(),
        'range': group['salary'].max() - group['salary'].min()
    })

df.groupby('dept').apply(get_salary_range)

# Row with the max value per group (using idxmax)
def get_top_performer(group):
    return group.loc[group['salary'].idxmax()]

df.groupby('dept').apply(get_top_performer)
```

**💡 Tip:** By default `groupby()` drops NaN keys. Use `dropna=False` to keep them as their own group:
```python
df.groupby('dept', dropna=False)['salary'].sum()
```

## 7.6 Ranking Within Groups

```python
# Rank within each group
df['dept_rank'] = df.groupby('dept')['salary'].rank(
    method='dense',
    ascending=False
)

# Percentile rank
df['percentile'] = df.groupby('dept')['salary'].rank(pct=True)

# Row number within group
df['row_num'] = df.groupby('dept').cumcount() + 1

# Get top N per group
top_earners = (
    df.sort_values('salary', ascending=False)
    .groupby('dept')
    .head(3)
)
```

## 7.7 Binning and Reshaping

```python
# Bin continuous values into categories
df['salary_band'] = pd.cut(
    df['salary'],
    bins=[0, 50000, 75000, 100000, float('inf')],
    labels=['Low', 'Medium', 'High', 'Very High']
)

# Count per group/bin combo, reshaped wide (groups as columns)
df.groupby(['dept', 'salary_band']).size().unstack(fill_value=0)

# stack() reverses unstack() - columns back to rows
df.groupby(['dept', 'salary_band']).size().unstack(fill_value=0).stack()
```

## 7.8 Pivot Tables

```python
# Basic pivot
pivot = df.pivot_table(
    values='sales',
    index='region',
    columns='product',
    aggfunc='sum'
)

# Multiple aggregations
pivot = df.pivot_table(
    values='sales',
    index='region',
    columns='product',
    aggfunc=['sum', 'mean', 'count']
)

# Multiple value columns
pivot = df.pivot_table(
    values=['sales', 'quantity'],
    index='region',
    columns='product',
    aggfunc='sum'
)

# With margins (totals)
pivot = df.pivot_table(
    values='sales',
    index='region',
    columns='product',
    aggfunc='sum',
    margins=True,
    margins_name='Total'
)
```

---

# 8. Merging and Joining

## 8.1 Merge Basics

```python
# Inner join (intersection)
merged = pd.merge(df1, df2, on='id', how='inner')

# Left join (all from left, matching from right)
merged = pd.merge(df1, df2, on='id', how='left')

# Right join (all from right, matching from left)
merged = pd.merge(df1, df2, on='id', how='right')

# Outer join (all from both)
merged = pd.merge(df1, df2, on='id', how='outer')

# Multiple key columns
merged = pd.merge(df1, df2, on=['id', 'date'], how='inner')
```

**💡 Interview Tip:** Understand the difference:
- `inner`: Only matching rows (default)
- `left`: All from left + matching from right
- `right`: All from right + matching from left
- `outer`: All from both (like SQL FULL OUTER JOIN)

## 8.2 Advanced Merging

```python
# Different column names
merged = pd.merge(
    df1, df2,
    left_on='emp_id',
    right_on='employee_id',
    how='inner'
)

# Multiple columns with different names
merged = pd.merge(
    df1, df2,
    left_on=['emp_id', 'dept'],
    right_on=['employee_id', 'department'],
    how='left'
)

# Handle duplicate column names
merged = pd.merge(
    df1, df2,
    on='id',
    suffixes=('_left', '_right')
)

# Merge on index
merged = pd.merge(
    df1, df2,
    left_index=True,
    right_index=True,
    how='inner'
)

# Indicator column (shows merge source)
merged = pd.merge(
    df1, df2,
    on='id',
    how='outer',
    indicator=True
)
# indicator column values: 'left_only', 'right_only', 'both'

# Validate merge cardinality (raises if assumption is violated)
merged = pd.merge(df1, df2, on='id', how='inner', validate='one_to_many')
# validate options: 'one_to_one', 'one_to_many', 'many_to_one', 'many_to_many'
```

**💡 Common Interview Question:** Self-join (employees with their managers)

```python
employees_with_managers = pd.merge(
    employees, employees,
    left_on='manager_id',
    right_on='emp_id',
    how='left',
    suffixes=('', '_manager')
)
# Result has columns: emp_id, name, manager_id, emp_id_manager, name_manager, etc.
```

## 8.3 Join Method

```python
# Join on index (left DataFrame index with right DataFrame index)
joined = df1.join(df2, how='inner')

# Join with suffix for overlapping columns
joined = df1.join(df2, lsuffix='_left', rsuffix='_right')

# Join on specific column
joined = df1.set_index('id').join(df2.set_index('id'))

# Join multiple DataFrames
result = df1.join([df2, df3], how='outer')
```

**💡 Interview Tip:** `.join()` joins on index by default, `.merge()` joins on columns. Use `.merge()` for more control.

## 8.4 Concatenate

```python
# Vertical concatenation (stack rows)
df_combined = pd.concat([df1, df2], axis=0)
df_combined = pd.concat([df1, df2], ignore_index=True)  # Reset index

# Horizontal concatenation (side by side)
df_combined = pd.concat([df1, df2], axis=1)

# With keys (multi-index)
df_combined = pd.concat(
    [df1, df2, df3],
    keys=['batch1', 'batch2', 'batch3']
)

# Only keep matching columns
df_combined = pd.concat([df1, df2], join='inner')

# Keep all columns (fill missing with NaN)
df_combined = pd.concat([df1, df2], join='outer')
```

**Example:**

```python
# Union of two datasets
df1 = pd.DataFrame({'A': [1, 2], 'B': [3, 4]})
df2 = pd.DataFrame({'A': [5, 6], 'B': [7, 8]})

result = pd.concat([df1, df2], ignore_index=True)
#    A  B
# 0  1  3
# 1  2  4
# 2  5  7
# 3  6  8
```

---

# 9. Time Series Operations

## 9.1 Date Parsing

```python
# Parse dates during read
df = pd.read_csv('data.csv', parse_dates=['date_column'])

# Convert to datetime
df['date'] = pd.to_datetime(df['date'])
df['date'] = pd.to_datetime(df['date'], format='%Y-%m-%d')
df['date'] = pd.to_datetime(df['date'], errors='coerce')  # Invalid -> NaT

# From components
df['date'] = pd.to_datetime(df[['year', 'month', 'day']])
```

## 9.2 Date Components

```python
# Extract components
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month
df['day'] = df['date'].dt.day
df['quarter'] = df['date'].dt.quarter
df['day_of_week'] = df['date'].dt.dayofweek  # 0=Monday, 6=Sunday
df['day_name'] = df['date'].dt.day_name()    # 'Monday', 'Tuesday', ...
df['month_name'] = df['date'].dt.month_name()

# Week of year
df['week'] = df['date'].dt.isocalendar().week

# Is weekend
df['is_weekend'] = df['date'].dt.dayofweek.isin([5, 6])
```

## 9.3 Date Filtering

```python
# Filter by date range
df[df['date'] >= '2024-01-01']
df[df['date'].between('2024-01-01', '2024-12-31')]

# Filter by year/month
df[df['date'].dt.year == 2024]
df[df['date'].dt.month == 6]
df[df['date'].dt.quarter == 2]

# Filter by day of week
df[df['date'].dt.dayofweek < 5]  # Weekdays only
df[df['date'].dt.dayofweek.isin([5, 6])]  # Weekends only
```

## 9.4 Date Grouping

```python
# Group by year/month/day
df.groupby(df['date'].dt.year)['sales'].sum()
df.groupby(df['date'].dt.to_period('M'))['sales'].sum()  # Monthly

# Using Grouper
df.groupby(pd.Grouper(key='date', freq='M'))['sales'].sum()  # Monthly
df.groupby(pd.Grouper(key='date', freq='W'))['sales'].sum()  # Weekly
df.groupby(pd.Grouper(key='date', freq='Q'))['sales'].sum()  # Quarterly

# Multiple grouping
df.groupby([
    pd.Grouper(key='date', freq='M'),
    'category'
])['sales'].sum()
```

**Frequency strings:**
- `D`: Day
- `W`: Week
- `M`: Month end
- `MS`: Month start
- `Q`: Quarter end
- `Y`: Year end

## 9.5 Rolling Windows

```python
# Rolling average (moving average)
df['rolling_avg'] = df['sales'].rolling(window=7).mean()

# Rolling sum
df['rolling_sum'] = df['sales'].rolling(window=7).sum()

# With minimum periods
df['rolling_avg'] = df['sales'].rolling(window=7, min_periods=1).mean()

# Centered window
df['centered_avg'] = df['sales'].rolling(window=7, center=True).mean()

# Rolling by group
df['rolling_avg_by_store'] = (
    df.groupby('store')['sales']
    .rolling(window=7, min_periods=1)
    .mean()
    .reset_index(level=0, drop=True)
)
```

**💡 Common Interview Question:** Calculate 7-day moving average

```python
# Method 1: Simple rolling
df['ma_7'] = df['value'].rolling(window=7).mean()

# Method 2: With date sorting
df = df.sort_values('date')
df['ma_7'] = df['value'].rolling(window=7, min_periods=1).mean()

# Method 3: By group
df['ma_7'] = (
    df.sort_values('date')
    .groupby('category')['value']
    .rolling(window=7, min_periods=1)
    .mean()
    .reset_index(level=0, drop=True)
)
```

## 9.6 Resampling

```python
# Set date as index first
df = df.set_index('date')

# Downsample (aggregate to lower frequency)
df.resample('M').sum()      # Monthly sum
df.resample('W').mean()     # Weekly average
df.resample('Q').sum()      # Quarterly sum

# Upsample (interpolate to higher frequency)
df.resample('D').ffill()    # Daily, forward fill
df.resample('H').interpolate()  # Hourly, interpolate

# Multiple aggregations
df.resample('M').agg({
    'sales': 'sum',
    'quantity': 'mean',
    'price': 'max'
})
```

---

# 10. Common Interview Patterns

## 10.1 Top N per Group

```python
# Get top 3 salaries per department
top_3 = (
    df.sort_values('salary', ascending=False)
    .groupby('department')
    .head(3)
)

# Using nlargest
top_3 = df.groupby('department').apply(
    lambda x: x.nlargest(3, 'salary')
).reset_index(drop=True)

# With ranking
df['rank'] = df.groupby('department')['salary'].rank(
    method='dense',
    ascending=False
)
top_3 = df[df['rank'] <= 3]
```

## 10.2 Cumulative Calculations

```python
# Cumulative sum
df['cumsum'] = df['sales'].cumsum()

# Cumulative sum by group
df['cumsum_by_dept'] = df.groupby('department')['sales'].cumsum()

# Cumulative product
df['cumprod'] = df['multiplier'].cumprod()

# Cumulative max/min
df['cummax'] = df['value'].cummax()
df['cummin'] = df['value'].cummin()

# Running count
df['running_count'] = range(1, len(df) + 1)
df['count_by_group'] = df.groupby('category').cumcount() + 1
```

## 10.3 Pivot and Unpivot

```python
# Pivot: Wide format
pivot_df = df.pivot(
    index='date',
    columns='product',
    values='sales'
)

# Unpivot: Long format (melt)
melted_df = pivot_df.reset_index().melt(
    id_vars='date',
    var_name='product',
    value_name='sales'
)

# With multiple value columns
df_wide = df.pivot(
    index='date',
    columns='metric',
    values=['value', 'count']
)
```

**Example:**

```python
# Before (long format):
#   date       product  sales
# 2024-01-01  A        100
# 2024-01-01  B        200
# 2024-01-02  A        150

# After pivot (wide format):
# product      A    B
# date
# 2024-01-01  100  200
# 2024-01-02  150  NaN
```

## 10.4 Window Functions

```python
# Difference from previous row
df['diff'] = df['value'].diff()
df['diff_by_group'] = df.groupby('category')['value'].diff()

# Percentage change
df['pct_change'] = df['value'].pct_change()
df['pct_change'] = df['value'].pct_change() * 100  # As percentage

# Shift (lag/lead)
df['prev_value'] = df['value'].shift(1)    # Previous row
df['next_value'] = df['value'].shift(-1)   # Next row
df['lag_2'] = df['value'].shift(2)         # 2 rows back
```

## 10.5 Data Sampling

```python
# Random sample
sample = df.sample(n=100)              # 100 random rows
sample = df.sample(frac=0.1)           # 10% of rows
sample = df.sample(n=100, replace=True)  # With replacement

# Stratified sampling
sample = df.groupby('category').apply(
    lambda x: x.sample(frac=0.1)
).reset_index(drop=True)

# Sample with seed (reproducible)
sample = df.sample(n=100, random_state=42)
```

## 10.6 Cross Tabulation

```python
# Frequency table
ct = pd.crosstab(df['category'], df['status'])

# With percentages
ct_pct = pd.crosstab(
    df['category'], df['status'],
    normalize='all'  # 'index', 'columns', or 'all'
)

# With margins (totals)
ct = pd.crosstab(
    df['category'], df['status'],
    margins=True
)

# With values
ct = pd.crosstab(
    df['category'], df['status'],
    values=df['sales'],
    aggfunc='sum'
)
```

## 10.7 String Aggregation

```python
# Concatenate strings per group
df.groupby('category')['name'].apply(', '.join)

# With transformation
df.groupby('category')['name'].apply(
    lambda x: ', '.join(sorted(x.unique()))
)

# Count unique
df.groupby('category')['name'].nunique()

# List of unique values
df.groupby('category')['name'].apply(lambda x: list(x.unique()))
```

## 10.8 Complex Transformations

```python
# Z-score normalization
df['z_score'] = (df['value'] - df['value'].mean()) / df['value'].std()

# Min-max scaling
df['scaled'] = (
    (df['value'] - df['value'].min()) / 
    (df['value'].max() - df['value'].min())
)

# Rank within groups
df['rank'] = df.groupby('category')['value'].rank(ascending=False)

# Percent of total
df['pct_of_total'] = df['value'] / df['value'].sum() * 100

# Percent of group total
df['pct_of_group'] = df.groupby('category')['value'].transform(
    lambda x: x / x.sum() * 100
)
```

---

## Quick Reference Card

### Essential Operations
```python
# Reading/Writing
pd.read_csv(), pd.read_excel(), df.to_csv(), df.to_excel()

# Inspection
df.head(), df.info(), df.describe(), df.shape, df.columns

# Selection
df['col'], df[['col1', 'col2']], df.loc[], df.iloc[]

# Filtering
df[df['col'] > value], df.query(), df.filter()

# Grouping
df.groupby().agg(), df.groupby().transform(), df.groupby().filter()

# Merging
pd.merge(), df.join(), pd.concat()

# Cleaning
df.dropna(), df.fillna(), df.drop_duplicates()

# String operations
df['col'].str.method()

# Date operations
df['col'].dt.method()
```

### Performance Tips
- Use `.query()` for complex filtering
- Use `.loc[]` instead of chained indexing
- Use vectorized operations instead of loops
- Use `pd.read_csv(chunksize=)` for large files
- Use `.astype()` for memory optimization
- Avoid `.apply()` when vectorized alternatives exist

### Common Pitfalls
- ❌ Chained assignment: `df[df['age'] > 25]['name'] = 'value'`
- ✅ Use `.loc[]`: `df.loc[df['age'] > 25, 'name'] = 'value'`

- ❌ Modifying copy: `df2 = df[df['age'] > 25]; df2['new'] = 1`
- ✅ Explicit copy: `df2 = df[df['age'] > 25].copy(); df2['new'] = 1`

- ❌ Using `append()` in loop: `for row in rows: df = df.append(row)`
- ✅ Build list then concat: `pd.concat([df] + list_of_rows)`

---

**Good luck with your Pandas interview! 🐼**