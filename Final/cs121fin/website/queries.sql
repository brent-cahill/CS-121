-- [Problem 4a]
SELECT title, upload_time, views FROM media
  WHERE username = 'bopeep'
  ORDER BY views DESC LIMIT 20;
  
  
-- [Problem 4b]
SELECT album_title, album_descrip, num_media, filename FROM 
  (SELECT album_id, COUNT(*) as num_media FROM album_media
   GROUP BY album_id) tb1
   
   NATURAL JOIN 
   
  (SELECT * FROM album WHERE username = 'garth') tb2
   
   LEFT JOIN
   
  (SELECT * FROM 
  (SELECT album_id, media_id FROM album_media
   WHERE summary_photo = 1 GROUP BY album_id) tb3
   NATURAL JOIN photos) tb4
   
   ON tb1.album_id = tb4.album_id;


-- [Problem 4c]
SELECT username, COUNT(*) as comments 
  FROM comments NATURAL JOIN user
  GROUP BY username ORDER BY comments DESC LIMIT 10;
	
