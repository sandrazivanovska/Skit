package karate.pettypes;

import com.intuit.karate.junit5.Karate;

class RunAllPetTypeTests {
    @Karate.Test
    Karate runAll() {
        // no path argument → picks up all .feature files next to this class
        return Karate.run().relativeTo(getClass());
    }
}
