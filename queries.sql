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

/*Milestone 3 */
-- Write queries (using JOIN) to answer the following questions:
-- What animals belong to Melody Pond?
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';
-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name
 FROM animals
 JOIN species ON animals.species_id = species.id
 WHERE species.name = 'Pokemon';
-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
ORDER BY owners.id;
-- How many animals are there per species?
SELECT s.name AS species, COUNT(*) AS animal_count
FROM animals a
JOIN species s ON a.species_id = s.id
GROUP BY s.name;
-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name 
FROM animals 
JOIN owners ON animals.owner_id = owners.id 
JOIN species ON animals.species_id = species.id 
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT * FROM animals 
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;
-- Who owns the most animals?
SELECT owners.full_name, COUNT(animals.id) as num_animals
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.id
ORDER BY num_animals DESC
LIMIT 1;

/* Milestone 4 */
--Write queries to answer the following:
--1.Who was the last animal seen by William Tatcher?
SELECT a.name
FROM animals AS a
JOIN visits AS v ON a.id = v.animals_id
WHERE v.vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher')
ORDER BY visit_date DESC
LIMIT 1;
--2.How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animals_id) 
FROM visits 
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');
-- 3.List all vets and their specialties, including vets with no specialties.
SELECT v.name AS vet_name, s.name AS specialty_name
FROM vets AS v
LEFT JOIN specializations AS sp ON v.id = sp.vet_id
LEFT JOIN species AS s ON sp.species_id = s.id;
--4.List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name, visits.visit_date
FROM animals
JOIN visits ON animals.id = visits.animals_id
JOIN vets ON vets.id = visits.vet_id
WHERE vets.name = 'Stephanie Mendez' AND visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30';
-- 5.What animal has the most visits to vets?
SELECT a.name, COUNT(*) as num_visits
FROM animals a
JOIN visits v ON a.id = v.animals_id
GROUP BY a.name
ORDER BY num_visits DESC
LIMIT 1;
-- 6.Who was Maisy Smith's first visit?
SELECT a.name AS animal_name, v.name AS vet_name, visit_date
FROM animals AS a
JOIN visits AS vs ON a.id = vs.animals_id
JOIN vets AS v ON vs.vet_id = v.id
WHERE v.name = 'Maisy Smith'
ORDER BY visit_date ASC
LIMIT 1;
-- 7. Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.*, v.*, visit_date
FROM visits
JOIN animals a ON a.id = visits.animals_id
JOIN vets v ON v.id = visits.vet_id
WHERE visit_date = (SELECT MAX(visit_date) FROM visits);
-- 8. How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS num_visits_no_specialization
FROM visits v
LEFT JOIN specializations s ON v.vet_id = s.vet_id
INNER JOIN animals a ON v.animals_id = a.id
WHERE v.id NOT IN (
  SELECT v.id
  FROM visits v
  INNER JOIN specializations s ON v.vet_id = s.vet_id
  WHERE s.species_id = a.species_id
);
-- 9.What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name, COUNT(*) AS num_visits
FROM visits
INNER JOIN animals ON visits.animals_id = animals.id
INNER JOIN species ON animals.species_id = species.id
INNER JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY num_visits DESC
LIMIT 1;