package karate.vets;

import com.intuit.karate.junit5.Karate;

class RunAllTests {
    @Karate.Test
    Karate runAll() {
        return Karate.run().tags("~@skip").relativeTo(getClass());
    }
}
