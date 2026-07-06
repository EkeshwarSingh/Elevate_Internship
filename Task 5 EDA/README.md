# Titanic Dataset - Exploratory Data Analysis (EDA)

## 📌 Project Overview

This project performs Exploratory Data Analysis (EDA) on the Titanic dataset using Python. The objective is to understand the dataset, identify missing values, explore relationships between variables, and extract meaningful insights through statistical summaries and visualizations.

---

## 🎯 Objective

- Understand the structure of the dataset.
- Perform statistical analysis.
- Identify missing values and data quality issues.
- Visualize distributions and relationships.
- Generate insights from passenger demographics and survival patterns.

---

## 🛠️ Tools & Libraries

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook

---

## 📂 Dataset Information

- Dataset: Titanic Data.csv
- Total Records: **1309**
- Total Features: **12** (after removing empty columns)

### Features

- PassengerId
- Survived
- Pclass
- Name
- Sex
- Age
- SibSp
- Parch
- Ticket
- Fare
- Cabin
- Embarked

---

## 🧹 Data Cleaning

The following preprocessing steps were performed:

- Loaded dataset using Pandas.
- Removed empty columns:
  - Unnamed: 12
  - Unnamed: 13
  - Unnamed: 14
- Checked data types using `.info()`.
- Examined missing values using `.isnull().sum()`.

---

## 📊 Exploratory Data Analysis

The following analyses were performed:

### Dataset Overview

- Shape of dataset
- Column names
- Data types
- Statistical summary

### Missing Value Analysis

Missing values found in:

- Age
- Fare
- Cabin
- Embarked

### Categorical Analysis

Used:

- value_counts()

Analyzed:

- Sex
- Passenger Class
- Survival
- Embarked

### Visualizations

The project includes:

- Histogram (Age Distribution)
- Boxplot (Fare Distribution)
- Countplot (Survival Count)
- Survival by Gender
- Passenger Class vs Survival
- Scatter Plot (Age vs Fare)
- Correlation Heatmap
- Pairplot

---

## 📈 Key Findings

- The dataset contains **1309 passengers**.
- Most passengers belong to **Third Class**.
- Male passengers outnumber female passengers.
- Female passengers had a significantly higher survival rate.
- First-class passengers survived more frequently than lower classes.
- Most passengers were between **20–40 years** of age.
- Fare contains several outliers.
- Cabin has the highest number of missing values.
- Passenger Class and Fare show a strong negative correlation.
- Age and Fare have only a weak relationship.

---

## 📁 Project Structure

```
Titanic_EDA/
│
├── Titanic Data.csv
├── Titanic_EDA.ipynb
├── EDA_Report.pdf
└── README.md
```

---

## ▶️ How to Run

1. Clone this repository.

```
git clone <repository-link>
```

2. Install required libraries.

```
pip install pandas numpy matplotlib seaborn
```

3. Open Jupyter Notebook.

```
jupyter notebook
```

4. Run all notebook cells.

---

## 📷 Output

The notebook generates:

- Statistical summaries
- Missing value analysis
- Histograms
- Boxplots
- Countplots
- Scatter plots
- Correlation heatmap
- Pairplot
- Final observations and conclusions

---

## 📌 Conclusion

This exploratory analysis provides a comprehensive understanding of the Titanic dataset. It highlights passenger demographics, survival trends, missing data patterns, feature relationships, and outliers. The analysis serves as a strong foundation for further data preprocessing and predictive machine learning models.

---

## 👨‍💻 Author

**Ekeshwar Singh**

M.Sc. Statistics  
Python | SQL | Power BI | Data Analytics | Machine Learning
