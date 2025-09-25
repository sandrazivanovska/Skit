package karate.owners;

import com.intuit.karate.junit5.Karate;

class RunAllOwnerTests {
    @Karate.Test
    Karate runAll() {
        return Karate.run().relativeTo(getClass());
    }
}
