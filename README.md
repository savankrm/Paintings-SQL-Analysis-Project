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
