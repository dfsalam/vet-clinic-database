/* Database schema to keep the structure of entire database. */

CREATE TABLE animals(
    id INT NOT NULL, 
    name TEXT NOT NULL, 
    date_of_birth DATE, 
    escape_attempts INT, 
    neutered BOOLEAN, 
    weight_kg NUMERIC(4,1)
);
/*Add a column species of type string to your animals table. */
ALTER TABLE animals ADD COLUMN species TEXT;
ALTER TABLE animals ALTER COLUMN species TYPE varchar(255);