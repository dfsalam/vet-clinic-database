/* Populate database with sample data. */
INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES (1, 'Agumon', '2020-02-03', 0, true, 10.23);

INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES (2, 'Gabumon', '2018-11-15', 2, true, 8.00);

INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES (3, 'Pikachu', '2021-01-07', 1, false, 15.04);

INSERT INTO animals (id, name, date_of_birth, escape_attempts, neutered) VALUES (4, 'Devimon', '2017-05-12', 5, true);
/* Milestone 2 */

/* Insertions */
INSERT INTO animals VALUES (5, 'Charmander', '2020-02-08', 0, false, -11.0);

INSERT INTO animals VALUES (6, 'Plantmon', '2021-11-15', 2, true, -5.7);

INSERT INTO animals VALUES (7, 'Squirtle', '1993-04-02', 3, false, -12.3), (8, 'Angemon', '2005-06-12', 1, true, -45.0);

INSERT INTO animals VALUES (9, 'Boarmon', '2005-06-07', 7, true, 20.4), (10, 'Blossom', '1998-10-13', 3, true, 17), (11, 'Ditto', '2022-05-14', 4, true, 22);

--Milestone 3
/* Insert the following data into the owners table:
Sam Smith 34 years old.
Jennifer Orwell 19 years old.
Bob 45 years old.
Melody Pond 77 years old.
Dean Winchester 14 years old.
Jodie Whittaker 38 years old. */
INSERT INTO owners (full_name, age)
VALUES
  ('Sam Smith', 34),
  ('Jennifer Orwell', 19),
  ('Bob', 45),
  ('Melody Pond', 77),
  ('Dean Winchester', 14),
  ('Jodie Whittaker', 38);

/* Insert the following data into the species table:
Pokemon
Digimon */
INSERT INTO species (name)
VALUES
  ('Pokemon'),
  ('Digimon');

/* Modify your inserted animals so it includes the species_id value:
If the name ends in "mon" it will be Digimon
All other animals are Pokemon */
UPDATE animals
SET species_id = (
  CASE 
    WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
    ELSE (SELECT id FROM species WHERE name = 'Pokemon')
  END
);

/* Modify your inserted animals to include owner information (owner_id):
Sam Smith owns Agumon.
Jennifer Orwell owns Gabumon and Pikachu.
Bob owns Devimon and Plantmon.
Melody Pond owns Charmander, Squirtle, and Blossom.
Dean Winchester owns Angemon and Boarmon. */

UPDATE animals SET owner_id = 1 WHERE name = 'Agumon';

UPDATE animals SET owner_id = 2 WHERE name = 'Gabumon' OR name = 'Pikachu';

UPDATE animals SET owner_id = 3 WHERE name = 'Devimon' OR name = 'Plantmon';

UPDATE animals SET owner_id = 4 WHERE name = 'Charmander' OR name = 'Squirtle' OR name = 'Blossom';

UPDATE animals SET owner_id = 5 WHERE name = 'Angemon' OR name = 'Boarmon';