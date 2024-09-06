import React from "react";
import { BrowserRouter as Router, Route, Link, Routes } from "react-router-dom";
import { useState } from "react";

// Home Page Component
const Home = () => (
  <div className="p-6">
    <h1 className="text-3xl font-bold mb-4">Welcome to the Voting dApp</h1>
    <p className="mb-4">
      This is a decentralized application for secure and transparent voting.
    </p>
    <Link
      to="/vote"
      className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
    >
      Start Voting
    </Link>
  </div>
);

// Voting Page Component
const Vote = () => {
  const [selectedOption, setSelectedOption] = useState("");

  const handleVote = () => {
    // Here you would typically interact with a smart contract
    console.log(`Voted for: ${selectedOption}`);
    alert(`Thank you for voting for ${selectedOption}!`);
  };

  return (
    <div className="p-6">
      <h2 className="text-2xl font-bold mb-4">Cast Your Vote</h2>
      <div className="mb-4">
        <label className="block mb-2">Select an option:</label>
        <select
          className="border p-2 rounded w-full"
          value={selectedOption}
          onChange={(e) => setSelectedOption(e.target.value)}
        >
          <option value="">-- Select --</option>
          <option value="Option A">Option A</option>
          <option value="Option B">Option B</option>
          <option value="Option C">Option C</option>
        </select>
      </div>
      <button
        onClick={handleVote}
        className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
        disabled={!selectedOption}
      >
        Submit Vote
      </button>
    </div>
  );
};

// Results Page Component
const Results = () => {
  // In a real app, you'd fetch this data from a blockchain or backend
  const mockResults = {
    "Option A": 42,
    "Option B": 28,
    "Option C": 30,
  };

  return (
    <div className="p-6">
      <h2 className="text-2xl font-bold mb-4">Voting Results</h2>
      <ul>
        {Object.entries(mockResults).map(([option, votes]) => (
          <li key={option} className="mb-2">
            {option}: {votes} votes
          </li>
        ))}
      </ul>
    </div>
  );
};

// Main App Component
const App = () => {
  return (
    <Router>
      <div className="min-h-screen bg-green-50">
        <nav className="bg-green-600 p-4">
          <ul className="flex space-x-4">
            <li>
              <Link to="/" className="text-white hover:underline">
                Home
              </Link>
            </li>
            <li>
              <Link to="/vote" className="text-white hover:underline">
                Vote
              </Link>
            </li>
            <li>
              <Link to="/results" className="text-white hover:underline">
                Results
              </Link>
            </li>
          </ul>
        </nav>

        <div className="container mx-auto mt-8">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/vote" element={<Vote />} />
            <Route path="/results" element={<Results />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
};

export default App;
