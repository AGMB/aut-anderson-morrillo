@REQ_HU_TEST @api_marvel_characters
Feature: Test de API súper simple

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'

  @id:1 @Get
  Scenario: Obtener todos los personajes
    Given path '/characters'
    When method get
    Then status 200
    * print response
    And def schemaValidate = read('characterSchema.json')
    And match each response[*] contains schemaValidate
    And match each response[*].powers[*] == '#string'

  @id:2 @Post @CreateUser
  Scenario: Crear Personaje Anderson Morrillo + UUID Random
    * def character = read('createCharacterBase.json')
    * def randomUuid = java.util.UUID.randomUUID()
    * set character.name = character.name + ' ' +randomUuid
    Given path '/characters'
    And request character
    When method post
    Then status 201
    * print response
    And match response.id == '#number'
    And match response.id == '#notnull'
    And match response.name == character.name
    And match each response.powers[*] == '#string'

  @id:3 @Post
  Scenario: Crear Personaje duplicado - error 400
    * def character = read('createCharacterBase.json')
    Given path '/characters'
    And request character
    When method post
    Then status 400
    * print response
    And match response.error contains 'exists'

  @id:4 @Put
  Scenario: Actualizar Personaje Base Anderson Morrillo
    * def id = 259
    * def character = read('createCharacterBase.json')
    * def randomUuid = java.util.UUID.randomUUID()
    * set character.description = 'updated description #' + ' ' +randomUuid
    Given path  'characters',id
    And request character
    When method put
    Then status 200
    * print response
    And match response.description == character.description
    And match response.id == id

  @id:5 @Delete
  Scenario: Eliminar Personaje creado previamente
    * def createdCharater = call read('karate-test.feature@CreateUser')
    * print createdCharater.response
    Given path 'characters',createdCharater.response.id
    When method delete
    Then status 204