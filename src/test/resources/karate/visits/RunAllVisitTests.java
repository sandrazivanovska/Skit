package karate.visits;

import com.intuit.karate.junit5.Karate;

class RunAllVisitTests {
    
    @Karate.Test
    Karate testVisitList() {
        return Karate.run("VisitList.feature").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testVisitGet() {
        return Karate.run("VisitGet.feature").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testAllVisits() {
        return Karate.run().relativeTo(getClass());
    }
}
