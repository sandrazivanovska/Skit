Feature: List Vets API (GET /vets)

  Background:
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']

  Scenario: List vets successfully returns 200 when vets exist
    Given path 'vets'
    When method GET
    Then status 200
    * assert response.length > 0

  Scenario: Delete all vets and verify empty list returns 404
    # 1) Fetch all existing vets
    Given path 'vets'
    When method GET

    # 2) Collect vet IDs (empty if no vets)
    * def vetIds = responseStatus == 200 ? response.map(x => x.id) : []

    # 3) Delete them all by calling the tagged scenario in THIS file
    * eval
    """
    var ids = vetIds;
    ids.forEach(function(id){
      karate.log('Deleting vet:', id);
      karate.call('classpath:karate/vets/VetAllGet.feature@deleteOneVet', { id: id });
    });
    """

    # 4) Verify no vets remain
    Given path 'vets'
    When method GET
    Then status 404


  @deleteOneVet
  @skip
  Scenario: Delete a single vet (callable)
    * url baseUrl
    * header Authorization = headers.Authorization
    * header Content-Type = headers['Content-Type']
    Given path 'vets', id
    When method DELETE
    Then assert responseStatus == 204 || responseStatus == 404
