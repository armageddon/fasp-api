CREATE TABLE `fasp`.`new_table` (
  `BUDGET_PROGRAM_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `BUDGET_ID` INT UNSIGNED NOT NULL,
  `PROGRAM_ID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`BUDGET_PROGRAM_ID`),
  INDEX `fk_new_table_budgetId_idx` (`BUDGET_ID` ASC) VISIBLE,
  INDEX `fk_new_table_programId_idx` (`PROGRAM_ID` ASC) VISIBLE,
  CONSTRAINT `fk_new_table_budgetId`
    FOREIGN KEY (`BUDGET_ID`)
    REFERENCES `fasp`.`rm_budget` (`BUDGET_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_new_table_programId`
    FOREIGN KEY (`PROGRAM_ID`)
    REFERENCES `fasp`.`rm_program` (`PROGRAM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


