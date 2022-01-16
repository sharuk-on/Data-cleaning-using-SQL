# Data-cleaning-using-SQL
## Standardizing, extracting, removing and filling in missing data were carried out to clean this dataset.

The dataset and idea for this project was acquired from Alex the analyst.

Tasks performed in this project
  - Removing time from datetime column 

  - Filling in ‘property address’

  - Extracting address and city from ‘property address’

  - Extracting address, city and state from ‘owner address’

  - Standardizing values in ‘sold as vacant’

  - Removing duplicates

  - Removing obsolete columns

  - Reordering columns

  - Renaming columns

### Removing time from datetime column:
The first thought is to use substring_index with space as separator to extract date. Once you know that it doesn’t work, you’ll realize you can use UPDATE statement with CONVERT function to change the data type to date. Upon execution, it doesn’t work either. After some troubleshooting it is apparent what’s the issue is.

Whatever advance query you try to execute to change the values of the column, it won’t work. It’s because the fundamental nature of the issue, which is, assigned data type of this column upon import is DATETIME. So changing values won’t work even if you try to manually type date one by one which will date along with default time 00:00:00.
By now it is obvious what’s the solution is, which is simple ALTER TABLE statement to MODIFY the datatype of the column from DATETIME to DATE.

### Filling in ‘property address’:
There are lot’s missing data in the dataset, some if which you can do nothing about. But it’s not the case for ‘Property address’, since there is a way to determine the address. Upon close inspection, you can figure out the relation between the ‘parcel id’ and ‘property address’ that is they are equivalent. There are instances where ‘parcel id’ doesn’t have address and on different row same ‘parcel id’ will have an address. 

So all we need to do to fill the empty address is to fetch the address from the row which have same parcel id. To achieve this several windows functions and CTE were used. NOTE: With the benefit of hindsight, I could have achieved the same result with simple JOIN clause.

### Extracting address, city and state from address:
This process is pretty straight forward, use substring_index function to split the string and extract the desired term and add new column then update the column with the extracted term.

### Standardizing values in ‘sold as vacant’:
This column has two different representations for ‘yes’ and ‘no’.  All we need to do is to use UPDATE statement with CASE function to standardize the values.

### Removing duplicates:
This was done using ROW_NUMBER function (window function) to identify the duplicates and remove them by using DELETE statement.

### Removing obsolete columns, Reordering and Renaming columns:
These are pretty self-explanatory.
