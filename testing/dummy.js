const fs = require("fs");
const csv = require("csv-parser");

// Path to your CSV file
const csvFilePath = "dummy data.csv";

const columnSums = {}; // Object to hold sums for each column
const columnCounts = {}; // Object to hold counts for each column

// Function to compute column values
function computeColumnValues() {
  console.log("Column Sums:");
  for (const [column, sum] of Object.entries(columnSums)) {
    console.log(`${column}: ${sum}`);
  }

  console.log("Column Averages:");
  for (const [column, count] of Object.entries(columnCounts)) {
    const average = columnSums[column] / count;
    console.log(`${column}: ${average}`);
  }
}

// Read and process the CSV file
fs.createReadStream(csvFilePath)
  .pipe(csv())
  .on("data", (row) => {
    for (const [column, value] of Object.entries(row)) {
      const numericValue = parseFloat(value) || 0;
      if (!columnSums[column]) {
        columnSums[column] = 0;
        columnCounts[column] = 0;
      }
      columnSums[column] += numericValue;
      columnCounts[column] += 1;
    }
  })
  .on("end", () => {
    computeColumnValues();
    console.log("CSV file successfully processed");
  })
  .on("error", (error) => {
    console.error("Error reading the CSV file:", error);
  });
