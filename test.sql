select p1.name, p1.grade 
from likes l join pupils p1 on l.id1 = p1.id join pupils p2 on l.id2 = p2.id
where p1.grade - p2.grade >=2
