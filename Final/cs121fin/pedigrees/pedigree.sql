-- [Problem 2a]
DROP PROCEDURE IF EXISTS sp_make_pedigree;
DELIMITER !

-- This procedure creates a pedigree of a certain length depending on the input
CREATE PROCEDURE sp_make_pedigree(animal_id INT, generations INT)
BEGIN
  DECLARE dam INTEGER;
  DECLARE sire INTEGER;
  DECLARE output VARCHAR(200);
  
  SET max_sp_recursion_depth = 255;
  
  -- This sets the animal's name and begins the pedigree
  IF NOT EXISTS (SELECT * FROM pedigree WHERE pedigree.animal_id = animal_id)
  THEN
  INSERT INTO pedigree VALUES (animal_id, 'A');
  END IF;
  
  -- calls the relationship, so we know which animal will be the next sire/dame
  SELECT relationship FROM (SELECT * FROM pedigree 
     WHERE pedigree.animal_id = animal_id
     ORDER BY LENGTH(relationship) DESC) tb1
     GROUP BY animal_id INTO output;
     
  -- Begin recursive "function"
  IF generations > 0 THEN
  SELECT sire_id, dam_id FROM breed_registry
    WHERE breed_registry.animal_id = animal_id
	INTO sire, dam;
    
    -- If this generation is a dame, find the next generation and output
    IF dam IS NOT NULL THEN
	  IF NOT EXISTS 
		(SELECT * FROM pedigree WHERE relationship = CONCAT(output, '.D'))
	  THEN
		INSERT INTO pedigree VALUES (dam, CONCAT(output, '.D'));
		CALL sp_make_pedigree(dam, generations - 1);
	  END IF;
    END IF;
    
	-- If this generation is a sire, find the next generation and output
    IF sire IS NOT NULL THEN
	  IF NOT EXISTS 
	    (SELECT * FROM pedigree WHERE relationship = CONCAT(output, '.S')) 
      THEN
	    INSERT INTO pedigree VALUES (sire, CONCAT(output, '.S'));
	    CALL sp_make_pedigree(sire, generations - 1);
	  END IF;
	END IF;
  END IF;
END !

DELIMITER ;


CALL sp_make_pedigree(175, 8);

select animal_id, pet_name, relationship
from pedigree natural join breed_registry;

DELETE FROM pedigree;

-- [Problem 2b]
SELECT * FROM
  (SELECT animal_id, registered_name, COUNT(*) AS num_times
  FROM breed_registry NATURAL JOIN pedigree
  GROUP BY animal_id) tb1 WHERE num_times > 1;


-- The following is the output for Dixie (175):

-- | animal_id | registered_name | num_times |
-- | ----------|-----------------|---------- |
-- | 3         | Jack            | 3         |
-- | 18        | Willow          | 2         |
-- | 20        | Macy            | 2         |
-- | 64        | Simba           | 2         |
-- | 76        | Diesel          | 2         |

