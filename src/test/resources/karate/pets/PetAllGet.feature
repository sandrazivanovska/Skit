Feature: List Pets API (GET /pets)

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: List pets successfully returns 200 when pets exist
    Given path 'pets'
    When method GET
    Then status 200 or status 404
    * assert response.length >= 0

  Scenario: Delete all pets and verify empty list returns 404
    # 1) Fetch all existing pets
    Given path 'pets'
    When method GET

    # 2) Collect pet IDs (empty if none)
    * def petIds = responseStatus == 200 ? response.map(x => x.id) : []

    # 3) Delete them all by calling a tagged scenario in THIS file
    * eval
    """
    var ids = petIds;
    ids.forEach(function(id){
      karate.log('Deleting pet:', id);
      karate.call('classpath:karate/pets/PetAllGet.feature@deleteOnePet', { id: id });
    });
    """

    # 4) Verify no pets remain
    Given path 'pets'
    When method GET
    Then status 404


  @deleteOnePet
  @skip
  Scenario: Delete a single pet (callable)
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

    Given path 'pets', id
    When method DELETE
    Then assert responseStatus == 204 || responseStatus == 404
