INSERT INTO `fasp`.`ap_static_label`(`STATIC_LABEL_ID`,`LABEL_CODE`,`ACTIVE`) VALUES ( NULL,'static.common.startTyping','1');
SELECT MAX(l.STATIC_LABEL_ID) INTO @MAX FROM ap_static_label l ;

INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,1,'Start typing to search'); -- en
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,2,'Commencez à taper pour rechercher'); -- fr
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,3,'Empieza a escribir para buscar'); -- sp 
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,4,'Comece a digitar para pesquisar'); -- pr
