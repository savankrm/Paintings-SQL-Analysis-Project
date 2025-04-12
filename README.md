# 🎨 Painting Database Analysis with SQL

## 📖 Overview
This project focuses on analyzing a dataset of famous paintings using SQL. The goal is to extract meaningful insights about paintings, artists, museums, and other related data. By leveraging SQL queries, we aim to answer specific questions and uncover trends within the dataset.

## 🗂️ Dataset Description
- **Source**: [Famous Paintings Dataset on Kaggle](https://www.kaggle.com/datasets/mexwell/famous-paintings)
- **Number of Records**: Multiple tables with thousands of records
- **Tables**:
  - **artist**: Contains details about artists, including their names, nationality, and lifespan.
  - **work**: Represents paintings, including their names, styles, and associated museums.
  - **museum**: Information about museums, including their location and contact details.
  - **museum_hours**: Operating hours of museums.
  - **product_size**: Pricing details for paintings based on canvas size.
  - **canvas_size**: Dimensions and labels for canvas sizes.
  - **subject**: Subjects or themes of paintings.
  - **image_link**: URLs for painting images.
- **Data Cleaning**:
  - Removed duplicate records from multiple tables.
  - Corrected inconsistent data (e.g., fixed misspelled days like "Thusday").
  - Ensured proper relationships between tables.

![ER Diagram](https://user-images.githubusercontent.com/your-image-link.png)

## 🎯 Objectives
- **Key Questions**:
  - Which paintings are not displayed in museums?
  - Which museums have the most paintings?
  - Who are the most popular artists?
  - What are the most popular painting styles?
- **Analysis Performed**:
  - Aggregations to count paintings, museums, and artists.
  - Joins to combine data from multiple tables.
  - Subqueries to identify trends and anomalies.
  - Ranking to determine popularity metrics.

## 🛠️ Tools & Technologies Used
- **SQL Dialect**: PostgreSQL
- **Platform**: pgAdmin
- **Other Tools**:
  - **Excel**: For initial data preparation.
  - **Python**: To insert CSV data into the database.

## 🔍 Analysis / Key Queries
This project showcases a variety of SQL skills and techniques, including:

### **1. Joins**
- Used to combine data from multiple tables, such as linking `work` with `artist` and `museum` to analyze relationships.
```sql
SELECT w.name AS painting, a.full_name AS artist, m.name AS museum
FROM work w
JOIN artist a ON w.artist_id = a.artist_id
JOIN museum m ON w.museum_id = m.museum_id;

2. Subqueries
Nested queries were used to filter and rank data, such as identifying the most popular painting styles.

WITH cte AS (
    SELECT style, COUNT(*) AS num_paintings, RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
    FROM work
    GROUP BY style
)
SELECT style
FROM cte
WHERE rank = 1;

3. Aggregations
Performed to calculate totals, averages, and counts, such as finding the number of paintings in each museum.

SELECT m.name, COUNT(w.work_id) AS number_of_paintings
FROM work w
JOIN museum m ON w.museum_id = m.museum_id
GROUP BY m.name
ORDER BY number_of_paintings DESC;

4. Ranking
Used RANK() and DENSE_RANK() to rank artists, museums, and painting styles based on popularity.

SELECT a.full_name, COUNT(w.work_id) AS num_paintings, RANK() OVER (ORDER BY COUNT(w.work_id) DESC) AS rank
FROM work w
JOIN artist a ON w.artist_id = a.artist_id
GROUP BY a.full_name
ORDER BY rank;

5. Data Cleaning
Removed duplicates and corrected inconsistencies in the dataset.

DELETE FROM work
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM work
    GROUP BY work_id
);

6. Window Functions
Used for advanced calculations, such as determining the most and least popular painting styles.

WITH cte AS (
    SELECT style, COUNT(*) AS num_paintings, RANK() OVER (ORDER BY COUNT(*) DESC) AS most, RANK() OVER (ORDER BY COUNT(*) ASC) AS least
    FROM work
    WHERE style IS NOT NULL
    GROUP BY style
)
SELECT style, CASE 
    WHEN most IN (1, 2, 3) THEN 'Most Popular'
    WHEN least IN (1, 2, 3) THEN 'Least Popular'
END AS popularity
FROM cte
WHERE most IN (1, 2, 3) OR least IN (1, 2, 3);

7. Case Statements
Used to categorize data, such as identifying the popularity of painting styles.

SELECT style, 
    CASE 
        WHEN COUNT(*) > 100 THEN 'Very Popular'
        ELSE 'Less Popular'
    END AS popularity
FROM work
GROUP BY style;

8. Common Table Expressions (CTEs)
Simplified complex queries by breaking them into smaller, reusable components.
WITH popular_styles AS (
    SELECT style, COUNT(*) AS num_paintings
    FROM work
    GROUP BY style
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
SELECT style, num_paintings
FROM popular_styles;

Example Query: Top 5 Most Popular Museums

SELECT m.name, COUNT(w.work_id) AS number_of_paintings
FROM work w
JOIN museum m ON w.museum_id = m.museum_id
GROUP BY m.name
ORDER BY number_of_paintings DESC
LIMIT 5;

Example Query Result:
Museum Name	Number of Paintings
Louvre Museum	120
The Met	95
<img alt="Sample Painting" src="https://user-images.githubusercontent.com/your-image-link.png">
📊 Insights & Findings
Patterns:
Certain museums dominate in terms of the number of paintings displayed.
Portraits are a popular subject, especially outside the USA.
Trends:
Some artists have their works displayed across multiple countries, indicating global popularity.
Anomalies:
Data inconsistencies like misspelled days and duplicate records were identified and corrected.
📁 Project Structure
Paintin_Case_Study.sql: Contains all SQL queries for analysis.
Images: Includes the ER diagram and sample painting images.
Results: Query outputs and insights.
🧠 Future Improvements / Next Steps
Add more advanced visualizations using Python or Tableau.
Perform sentiment analysis on painting descriptions (if available).
Expand the dataset to include more museums and artists.
🚀 How to Run the Project
Clone the repository.
Import the dataset into a PostgreSQL database.
Open Paintin_Case_Study.sql in pgAdmin and execute the queries.
Review the results and insights.
🙌 Acknowledgements
Techtfq YouTube Channel for SQL learning resources.
📬 Contact
Feel free to reach out for collaboration or queries: [Your Contact Info] ```
