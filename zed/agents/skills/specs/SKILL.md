---
name: specs
description: Project pattern for RSpec files
disable-model-invocation: false
---

## Core Rules (NO EXCEPTIONS)

### 1. Subject Declaration
- **MUST** declare `subject` at the beginning of EVERY `describe` or `context` block
- Pattern: `subject(:name) { described_class.new(arg) }`
- If you're testing a method that returns a value, make the subject BE that method call
- Example: `subject(:result) { parser.parse }` not `subject(:parser) { described_class.new(...) }`

### 2. One Expectation Per It Block (STRICT)
- **ONLY ONE `expect()` statement per `it` block - NO EXCEPTIONS**
- If you need to check multiple things, create multiple `it` blocks
- ❌ WRONG:
  ```ruby
  it do
    expect(proxy.request).to include('Test!!!')
    expect(proxy.request).to include('test')
  end
  ```
- ✅ RIGHT:
  ```ruby
  it { expect(proxy.request).to include('Test!!!') }
  it { expect(proxy.request).to include('test') }
  ```

### 3. Let Variables (ALL DATA)
- **ALL test data must come from `let` variables - NEVER hardcode in it blocks**
- All test data, even inline strings, should be extracted to `let` if they might need changing
- Override `let` values in contexts to test different scenarios
- Example:
  ```ruby
  let(:event_comment) { 'test' }
  context 'with empty comment' do
    let(:event_comment) { '' }  # Override parent let
  end
  ```

### 4. It Block Formatting (Line Length Rule)

**Use `it { ... }` (single-line braces) WHEN IT FITS:**
- "Fits" = entire line is under ~100 characters including indentation
- `it { expect(proxy.external_order_id).to eq(transaction_id) }` ✅
- `it { expect(proxy.request).to include('Appraisal Appeal') }` ✅

**Use `it do ... end` (multi-line) WHEN IT DOESN'T FIT:**
- Line is too long with braces
- `it do` followed by expect on next line
- Multiple lines for continuation (with `\`)
- **NO string descriptions after `it do` - descriptions go in context blocks**
- ✅ RIGHT:
  ```ruby
  it do
    expect(proxy.request).to include('[Appraisal Appeal]')
  end
  ```
- ❌ WRONG:
  ```ruby
  it "should include reason code" do
    expect(proxy.request).to include('[Appraisal Appeal]')
  end
  ```

### 5. Hash Formatting in Let Variables

**Preferred (horizontal when it fits):**
```ruby
let(:content) do
  { 'TransactionID' => transaction_id,
    'ProductList' => { 'Product' => { 'Event' => event_data } },
    'external_id' => external_id }
end
```

**Breaking nested hashes to keep line length reasonable:**
When a single line gets too long (>100 chars), break nested hashes while keeping opening `{` on the same line as the key:
```ruby
let(:revision_content) do
  { 'TransactionID' => '13520355-4545455000AM',
    'ProductList' => { 'Product' => {
      'UniqueID' => '1',
      'Event' => { 'RECCode' => '793',
                   'EventDate' => '2026/05/08 05:17:33',
                   'Comment' => 'Test Comment',
                   'EventID' => '3153065354' }
    } },
    'external_id' => '13520355-4545455000AM-rov-3153065354',
    'revision_type' => 'reconsideration_of_value' }
end
```

**Key points for nested hash breaks:**
- Nested hash opening `{` stays on same line as the key (e.g., `'Product' => {`)
- Content of nested hash continues on next line, indented consistently
- Closing `}` aligns properly with opening key
- Inner hashes can also break if needed (maintain alignment)
- Keeps horizontal flow while respecting line length limits
- Avoids wasteful blank-line expansion

**Fallback (vertical - ONLY if you can't break reasonably):**
```ruby
let(:event_data) do
  { 'Comment' => event_comment,
    'RECCode' => '155',
    'EventDate' => '2025/08/24 06:14:05',
    'ReasonList' => { 'Reason' => { 'ReasonCode' => reason_code,
                                    'ReasonDesc' => reason_desc,
                                    'Comments' => reason_comment } },
    'EventID' => '3140573449' }
end
```

**AVOID (wasteful spacing):**
```ruby
let(:content) do
  {
    'TransactionID' => transaction_id,
    'ProductList' => {
      'Product' => {
        'Event' => event_data
      }
    },
    'external_id' => external_id
  }
end
```

### 6. Describe/Context Naming
- Instance methods: `describe '#method_name'`
- Class methods: `describe '.method_name'`
- Context blocks: descriptive names without `it` prefix
  - ✅ `context 'with both reason comment and event comment'`
  - ❌ `context 'it should handle both comments'`

### 7. Mocks and Spies (Prefer `have_received`)

**ALWAYS prefer `have_received` over `receive` when possible:**
- Use `spy()` to create a spy instance
- Mock the class to return the spy
- Call the code being tested
- Then assert with `have_received()`

✅ RIGHT (use `have_received`):
```ruby
let(:workflow_service) { spy(Ordering::ClientRequestWorkflowService) }

before do
  allow(Ordering::ClientRequestWorkflowService).to receive(:new).and_return(workflow_service)
end

it do
  process_rov
  expect(workflow_service).to have_received(:request_reconsideration_of_value).with(
    hash_including(order_id: order.id)
  )
end
```

❌ WRONG (only use `receive` as last resort):
```ruby
it do
  expect_any_instance_of(Ordering::ClientRequestWorkflowService)
    .to receive(:request_reconsideration_of_value).with(...)
  process_rov  # expectation set BEFORE execution
end
```

**Why?** `have_received` is clearer: action first, assertion second. Also works better with spies vs `expect_any_instance_of`.

### 8. `let!` vs `before` for Side Effects

Use `let!` **only** when the variable is referenced by name somewhere in the spec. If it exists purely for its side effect (database record creation, stub setup, etc.), use `before` instead.

❌ WRONG (`let!` not referenced anywhere):
```ruby
context 'when vendor has no insurance' do
  let!(:ordering_vendor) { create(:ordering_vendor_user, id: vendor.id, skip_insurance: true) }

  it { expect(policy).not_to permit(vendor, order) }
end
```

✅ RIGHT (pure side effect → `before`):
```ruby
context 'when vendor has no insurance' do
  before { create(:ordering_vendor_user, id: vendor.id, skip_insurance: true) }

  it { expect(policy).not_to permit(vendor, order) }
end
```

When multiple side-effect setups belong to the same context, group them in a single `before do...end`:
```ruby
context 'when vendor has an expired license' do
  before do
    create(:ordering_vendor_user, id: vendor.id, skip_license: true)
    create(:ordering_appraiser_license, user_id: vendor.id, expires_at: 1.day.ago)
  end

  it { expect(policy).not_to permit(vendor, order) }
end
```

### 9. What NOT To Do
- ❌ Custom helper methods in specs (extract to factory or shared helper)
- ❌ Test private/protected methods directly
- ❌ Hardcoded values in it blocks (use let)
- ❌ Multiple expectations per it block
- ❌ String descriptions for `it do ... end` blocks
- ❌ Wasted vertical space in hashes
- ❌ Using `include()` matcher when you need exact value (use `eq()`)
- ❌ Using `expect_any_instance_of(...).to receive()` - use spy + `have_received` instead

## When Modifying Existing Specs

**CRITICAL:** If you make edits to a spec file, PRESERVE the existing formatting:
- If `let` variables use horizontal hashes, keep them horizontal
- If `it { ... }` blocks are single-line, don't expand them to `do/end`
- If someone already formatted it correctly, don't "improve" it
- Only change what's necessary for your update

## RuboCop Configuration
- Run `bundle exec rubocop` on your spec files before committing
- This project uses RSpec linting rules - violations will fail CI
- Common violations: MultipleExpectations, DescribedClass misuse, etc.

## Reference Examples
- Look at existing specs in the same directory for the same provider/module
- Example pattern files are your best reference for the exact formatting style
- When in doubt, match the style of recently-written tests in the same area
