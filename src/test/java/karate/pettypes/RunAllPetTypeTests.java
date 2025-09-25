package karate.pettypes;

import com.intuit.karate.junit5.Karate;

class RunAllPetTypeTests {
    @Karate.Test
    Karate runAll() {
        return Karate.run().relativeTo(getClass());
    }
}
