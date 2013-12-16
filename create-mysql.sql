CREATE DATABASE tomte_development DEFAULT CHARACTER SET 'utf8';

GRANT ALL PRIVILEGES ON tomte_development.* TO 'tomten'@'%' IDENTIFIED BY 'tomten';
GRANT ALL PRIVILEGES ON tomte_development.* TO 'tomten'@'localhost' IDENTIFIED BY 'tomten';

CREATE DATABASE tomte_test DEFAULT CHARACTER SET 'utf8';

GRANT ALL PRIVILEGES ON tomte_test.* TO 'tomten'@'%' IDENTIFIED BY 'tomten';
GRANT ALL PRIVILEGES ON tomte_test.* TO 'tomten'@'localhost' IDENTIFIED BY 'tomten';

CREATE DATABASE tomte_production DEFAULT CHARACTER SET 'utf8';

GRANT ALL PRIVILEGES ON tomte_production.* TO 'tomten'@'%' IDENTIFIED BY 'tomten';
GRANT ALL PRIVILEGES ON tomte_production.* TO 'tomten'@'localhost' IDENTIFIED BY 'tomten';
