package karate.visits;

import com.intuit.karate.junit5.Karate;

class RunAllVisitTests {
    @Karate.Test
    Karate runAll() {
        return Karate.run().relativeTo(getClass());
    }
}
