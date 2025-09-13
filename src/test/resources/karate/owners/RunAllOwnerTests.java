package karate.owners;

import com.intuit.karate.junit5.Karate;

class RunAllOwnerTests {
    
    @Karate.Test
    Karate testOwnerList() {
        return Karate.run("OwnerList.feature").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testOwnerGet() {
        return Karate.run("OwnerGet.feature").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testOwnerCreate() {
        return Karate.run("OwnerCreate.feature").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testOwnerUpdate() {
        return Karate.run("OwnerUpdate.feature").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testOwnerDelete() {
        return Karate.run("OwnerDelete.feature").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testAllOwners() {
        return Karate.run().relativeTo(getClass());
    }
}
