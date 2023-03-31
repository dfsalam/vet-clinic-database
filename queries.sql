/*Queries that provide answers to the questions from all projects.*/
/* Find all animals whose name ends in "mon". */
SELECT name FROM animals WHERE name LIKE '%mon';

/* List the name of all animals born between 2016 and 2019. */
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

/* List the name of all animals that are neutered and have less than 3 escape attempts. */
SELECT name FROM animals WHERE neutered = TRUE AND escape_attempts < 3;

/* List the date of birth of all animals named either "Agumon" or "Pikachu". */
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

/* List name and escape attempts of animals that weigh more than 10.5kg */
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

/* Find all animals that are neutered. */
SELECT * FROM animals WHERE neutered = TRUE;

/* Find all animals not named Gabumon. */
SELECT * FROM animals WHERE name <> 'Gabumon';

/* Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg) */
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/* Milestone 2 */
/* Transaction 1 */
BEGIN;
UPDATE animals SET species='unspecified';
ROLLBACK;

/* Transaction 2 */
BEGIN;
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
UPDATE animals SET species='pokemon' WHERE species IS NULL;
COMMIT;

/* Transaction 3 */
BEGIN;
DELETE FROM animals;
ROLLBACK;

/*Transaction 4 */
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SELECT * FROM animals ORDER BY id;
SAVEPOINT transaction4;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals ORDER BY id;
ROLLBACK TO transaction4;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

/*  QUERIES FOR... */
/* How many animals are there? Answer: 10*/
SELECT COUNT(id) FROM animals; 
/* How many animals have never tried to escape? A: 2*/
SELECT COUNT(id) FROM animals WHERE escape_attempts=0;
/* What is the average weight of animals? A: 16.066*/
SELECT AVG(weight_kg) FROM animals;
-- Who escapes the most, neutered or not neutered animals? Answer:neutered
SELECT SUM(escape_attempts) FROM animals WHERE neutered = TRUE;
SELECT SUM(escape_attempts) FROM animals WHERE neutered = FALSE;
SELECT COUNT(id) FROM animals WHERE neutered=TRUE;
SELECT COUNT(id) FROM animals WHERE neutered=FALSE;
-- What is the minimum and maximum weight of each type of animal?
--ANSWER: Digimon{min: 5.7kg, max: 45.0}
SELECT MIN(weight_kg) FROM animals WHERE species='digimon';
SELECT MAX(weight_kg) FROM animals WHERE species='digimon';
--ANSWER: Pokemon{min: 11.0kg, max: 17.0}
SELECT MIN(weight_kg) FROM animals WHERE species='pokemon';
SELECT MAX(weight_kg) FROM animals WHERE species='pokemon';
-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) FROM animals WHERE EXTRACT(YEAR FROM date_of_birth) BETWEEN 1990 AND 2000 GROUP BY species;
-- Answer Pokemon avg=3.00, Digimon no data